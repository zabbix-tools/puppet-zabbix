#!/bin/sh
ZABBIX_SERVER_CONF=/etc/zabbix/zabbix_server.conf
CHECK_QUERY="SELECT mandatory FROM dbversion;"

function die() {
	echo $@ >&2
	exit 1
}

# start up checks
[[ -f "${ZABBIX_SERVER_CONF}" ]] || die "Zabbix server configuration file not found: ${ZABBIX_SERVER_CONF}"
which psql >/dev/null 2>&1 || die "PostgreSQL client binary not found in PATH"
which zcat >/dev/null 2>&1 || die "zcat binary not found in PATH"
which zabbix_server >/dev/null 2>&1 || die "Zabbix Server binary not found in PATH"

# get zabbix server version
ZABBIX_SERVER_VERSION=$(zabbix_server -V | head -n 1 | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+')
ZABBIX_DATABASE_SCRIPTS="/usr/share/doc/zabbix-server-pgsql-${ZABBIX_SERVER_VERSION}"

# read zabbix server database connection config
eval $(grep '^DB' ${ZABBIX_SERVER_CONF})

# build connection command
PSQL="psql --no-password --no-align --tuples-only"
if [[ -n "${DBSocket}" ]]; then
	[[ -n "${DBHost}" ]] && PSQL="${PSQL} --host=${DBSocket}"
	[[ -n "${DBUser}" ]] && PSQL="sudo -u ${DBUser} ${PSQL}"
else
	[[ -n "${DBHost}" ]] && PSQL="${PSQL} --host=${DBHost}"
	[[ -n "${DBPort}" ]] && PSQL="${PSQL} --port=${DBPort}"
	[[ -n "${DBUser}" ]] && PSQL="${PSQL} --username=${DBUser}"
fi
[[ -n "${DBPassword}" ]] && export PGPASSWORD="${DBPassword}"
[[ -n "${DBName}" ]] && PSQL="${PSQL} --dbname=${DBName}"

# check db connection
$PSQL -c "SELECT 1;" >/dev/null || die

# check if db is provisioned
$PSQL -c "${CHECK_QUERY}" >/dev/null 2>&1
PROVISIONED=$?

# exit if just checking
[[ "$1" == "check" ]] && exit $PROVISIONED

# setup database
if [[ $PROVISIONED -ne 0 ]]; then
	# newer versions of zabbix have a single create.sql.gz file
	if [[ -f "${ZABBIX_DATABASE_SCRIPTS}/create.sql.gz" ]]; then
		zcat "${ZABBIX_DATABASE_SCRIPTS}/create.sql.gz" | $PSQL >/dev/null 2>&1 \
			|| die "Error running database creation script"
	else
		[[ -f "${ZABBIX_DATABASE_SCRIPTS}/create/schema.sql" ]] \
			|| die "Zabbix database scripts not found: ${ZABBIX_DATABASE_SCRIPTS}"

		$PSQL --file="${ZABBIX_DATABASE_SCRIPTS}/create/schema.sql" >/dev/null 2>&1 \
			|| die "Error running database creation script"

		$PSQL --file="${ZABBIX_DATABASE_SCRIPTS}/create/images.sql" >/dev/null 2>&1 \
			|| die "Error running database image import script"

		$PSQL --file="${ZABBIX_DATABASE_SCRIPTS}/create/data.sql" >/dev/null 2>&1 \
			|| die "Error running database data import script"
	fi

	# double check
	$PSQL -c "${CHECK_QUERY}" >/dev/null 2>&1 \
		|| die "Database creation scripts ran but the desired tables were not found"
fi

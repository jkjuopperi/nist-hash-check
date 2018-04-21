#!/bin/sh

generate () {
	cat <<-EOF
	BEGIN;
	CREATE TABLE IF NOT EXISTS mfg (MfgCode integer PRIMARY KEY NOT NULL, MfgName text NOT NULL);
	CREATE TABLE IF NOT EXISTS os (
		OpSystemCode integer PRIMARY KEY NOT NULL,
		OpSystemName text NOT NULL,
		OpSystemVersion text,
		MfgCode integer REFERENCES mfg (MfgCode)
	);
	CREATE TABLE IF NOT EXISTS prod (
		ProductCode integer NOT NULL,
		ProductName text NOT NULL,
		ProductVersion text,
		OpSystemCode integer REFERENCES os (OpSystemCode),
		MfgCode integer REFERENCES mfg (MfgCode),
		Language text,
		ApplicationType text
	);
	CREATE TABLE IF NOT EXISTS file (
		"SHA-1" text,
		"MD5" text,
		"CRC32" text,
		FileName text NOT NULL,
		FileSize bigint,
		ProductCode integer,
		OpSystemCode integer REFERENCES os (OpSystemCode),
		SpecialCode text
	);
	EOF

	cat <<-EOF
	COPY mfg FROM STDIN ( FORMAT CSV, HEADER true, ENCODING 'UTF-8', DELIMITER ',', QUOTE '"', ESCAPE '\' );
	EOF
	iconv -f UTF-8 -t UTF-8 --byte-subst="<0x%x>" --unicode-subst="<U+%04X>" nsrlmfg.txt
	echo '\.'

	cat <<-EOF
	COPY os FROM STDIN ( FORMAT CSV, HEADER true, ENCODING 'UTF-8', DELIMITER ',', QUOTE '"', ESCAPE '\' );
	EOF
	iconv -f UTF-8 -t UTF-8 --byte-subst="<0x%x>" --unicode-subst="<U+%04X>" nsrlos.txt
	echo '\.'

	cat <<-EOF
	COPY prod FROM STDIN ( FORMAT CSV, HEADER true, ENCODING 'UTF-8', DELIMITER ',', QUOTE '"', ESCAPE '\' );
	EOF
	iconv -f UTF-8 -t UTF-8 --byte-subst="<0x%x>" --unicode-subst="<U+%04X>" nsrlprod.txt
	echo '\.'

	cat <<-EOF
	COPY file FROM STDIN ( FORMAT CSV, HEADER true, ENCODING 'UTF-8', DELIMITER ',', QUOTE '"' );
	EOF
	iconv -f UTF-8 -t UTF-8 --byte-subst="<0x%x>" --unicode-subst="<U+%04X>" nsrlfile.txt
	echo '\.'

	cat <<-EOF
	CREATE INDEX file_sha1_idx ON file ("SHA-1");
	COMMIT;
	EOF
}

generate | psql $@

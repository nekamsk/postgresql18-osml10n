## Software requirements:

* GNU/Linux OS
* PostgreSQL 18 or newer, PostGIS 3 or newer
* Kanji Kana Simple Inverter library (KAKASI)
* ICU - International Components for Unicode library

This code is modified on RED OS 8 and should also work on RHEL-based
distributions and other GNU/Linux distributions.

On RED OS, all required libraries should be installed from the
distribution. Please do not compile them from source.


To install the l10n into your database the following steps are required:

### 1. Install the RPM package

Install the PostgreSQL 18 RPM package using DNF:

```sh
sudo dnf install ./postgresql18-osml10n-2.5.10-1.*.rpm
```

The package installs the PostgreSQL extension files and shared libraries
in the directories reported by PostgreSQL `pg_config`.

The RPM package requires PostgreSQL 18, PostGIS, `postgresql18-contrib`
and `postgresql18-plpython3`.

If you build the RPM yourself, the required development packages are
listed in the RPM spec file.

Thai transcript is a separate extension because it is based on Python
and requires the TLTK package. If TLTK is not installed,
Thai transcription will fall back to ICU.

### 2. Load the required extensions into your database

```sql
CREATE EXTENSION osml10n CASCADE;
CREATE EXTENSION osml10n_thai_transcript CASCADE;
```

If you already installed the previous version of this software use:

```sql
ALTER EXTENSION osml10n UPDATE;
ALTER EXTENSION osml10n_thai_transcript UPDATE;
```

**WARNING: This will only work from the previous version to the
current version, not across multiple versions.**

After installing or updating the extension you should be able to do the following:

```sql
yourdb=# select osml10n_translit('北京');
 osml10n_translit
---------------
 běi jīng
 (1 row)
```

```sql
yourdb=# select osml10n_kanji_transcript('漢字');
 osml10n_kanji_transcript
---------------------
 kanji
 (1 row)
```

```sql
yourdb=# select osml10n_thai_transcript('ถนนข้าวสาร');
 osml10n_thai_transcript
-------------------------
 thanon khaosan
 (1 row)
```

To check if everything went well run the test script provided in
`tests/runtests_in_virtualenv.sh`.

The test uses `pg_virtualenv`, so a permanent test database is not required.


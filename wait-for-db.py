#!/usr/bin/env python3
import os
import re
import sys
import time

import psycopg2


def to_libpq_uri(database_uri: str) -> str:
    """Strip a SQLAlchemy driver suffix (e.g. postgresql+psycopg://) so libpq accepts it."""
    return re.sub(r"^(postgres(?:ql)?)\+[^:]+://", r"\1://", database_uri)


def main() -> int:
    if len(sys.argv) != 2:
        print("usage: wait-for-db.py <database-uri>", file=sys.stderr)
        return 2

    database_uri = to_libpq_uri(sys.argv[1])
    timeout_seconds = int(os.environ.get("DB_CONNECT_TIMEOUT", "60"))
    deadline = time.monotonic() + timeout_seconds
    attempt = 0

    while True:
        attempt += 1
        try:
            connection = psycopg2.connect(database_uri)
            connection.close()
            print(f"database connection succeeded after {attempt} attempt(s)")
            return 0
        except psycopg2.OperationalError as exc:
            if time.monotonic() >= deadline:
                print(
                    f"database connection failed after {attempt} attempt(s): {exc}",
                    file=sys.stderr,
                )
                return 1

            print(f"waiting for database (attempt {attempt}): {exc}", file=sys.stderr)
            time.sleep(2)


if __name__ == "__main__":
    raise SystemExit(main())

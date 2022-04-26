SELECT
    *
WHERE
    date >= "2015-01-01"
    AND (
        fbi_code LIKE "01A"
        OR fbi_code LIKE "02"
        OR fbi_code LIKE "03"
        OR fbi_code LIKE "04A"
        OR fbi_code LIKE "04B"
        OR fbi_code LIKE "05"
        OR fbi_code LIKE "06"
        OR fbi_code LIKE "07"
        OR fbi_code LIKE "09"
    )
LIMIT
    100000000
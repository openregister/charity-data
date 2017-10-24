SELECT 
    CONCAT(extract_charity.regno,
            `extract_charity`.`regno`,
            '-',
            extract_charity.subno) AS 'charity',
    `extract_charity`.`name`,
    `extract_charity`.`aob` AS 'operating area',
    `extract_charity`.`postcode` AS 'address',
    `extract_registration`.`regdate` AS 'start-date',
    `extract_registration`.`remdate` AS 'end-date'
FROM
    `charity`.`extract_charity`
        LEFT OUTER JOIN
    `charity`.`extract_registration` ON `extract_charity`.`regno` = `extract_registration`.`regno`
        AND `extract_charity`.`subno` = `extract_registration`.`subno`
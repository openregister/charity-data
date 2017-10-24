SELECT 
    ANY_VALUE(CONCAT(`extract_charity`.`regno`,
                    '-',
                    extract_charity.subno)) AS 'charity',
    ANY_VALUE(`extract_charity`.`name`) AS 'name',
    ANY_VALUE(`extract_main_charity`.coyno) AS 'company',
    GROUP_CONCAT(DISTINCT `extract_class`.`class`
        ORDER BY extract_class.class DESC
        SEPARATOR ';') AS 'class',
    ANY_VALUE(`extract_charity`.`postcode`) AS 'address',
    ANY_VALUE(`extract_registration`.`regdate`) AS 'start-date',
    ANY_VALUE(`extract_registration`.`remdate`) AS 'end-date'
FROM
    `charity`.`extract_charity`
         left OUTER JOIN
    `charity`.`extract_registration` ON `extract_charity`.`regno` = `extract_registration`.`regno`
        AND `extract_charity`.`subno` = `extract_registration`.`subno`
        LEFT OUTER JOIN
    `charity`.`extract_class` ON `extract_charity`.`regno` = `extract_class`.`regno`
        LEFT OUTER JOIN
    `charity`.`extract_main_charity` ON extract_charity.regno = extract_main_charity.regno
GROUP BY extract_charity.regno, extract_charity.subno, extract_registration.regdate, extract_registration.remdate
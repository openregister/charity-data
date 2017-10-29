SELECT 
    `charity_register`.`charity`,
    `charity_register`.`name`,
    `charity_register`.`company`,
    `charity_register`.`class`,
    `deliverypointview`.`UPRN`,
    `charity_register`.`start-date`,
    `charity_register`.`end-date`
FROM
    `charity`.`charity_register`
       LEFT OUTER JOIN
    `addressbase`.`deliverypointview` ON (`charity_register`.`postcode` = `deliverypointview`.`postcode`
        AND `deliverypointview`.`addnumber` = `charity_register`.`add1`)
        OR (`charity_register`.`postcode` = `deliverypointview`.`postcode`
        AND `deliverypointview`.`addname` = `charity_register`.`add1`)

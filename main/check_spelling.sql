UPDATE people
SET
    name = CASE
        WHEN name = 'Anna' THEN 'Ana'
        WHEN name = 'Bartolome' THEN 'Bartholome'
        WHEN name = 'Catalina' THEN 'Cathalina'
        WHEN name = 'Guillem' THEN 'Guillermo'
        WHEN name = 'Jaime' THEN 'Jayme'
        WHEN name = 'Margharita' THEN 'Margarita'
        WHEN name = 'Rafel' THEN 'Rafael'
        ELSE name
    END,
    surname1 = CASE
        WHEN surname1 = 'Cantallops' THEN 'Cantellops'
        WHEN surname1 = 'Coll' THEN 'Coli'
        WHEN surname1 = 'Llompart' THEN 'Llompard'
        ELSE surname1
    END,
    surname2 = CASE
        WHEN surname2 = 'Company' THEN 'Compañy'
        WHEN surname2 = 'Llompart' THEN 'Llompard'
        ELSE surname2
    END;
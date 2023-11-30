-- 1. Selecione todas as peças produzidas na última semana.
SELECT *
FROM ordens_prod
WHERE data_termino >= DATE_SUB(CURDATE(), INTERVAL 7 DAY);

-- 2. Encontre a quantidade total de peças produzidas por cada máquina.
SELECT m.id_maquina, m.nome_maquina, SUM(op.quantidade) AS total_de_pecas
FROM maquinas m
INNER JOIN ordens_prod op ON op.id_peca IN (SELECT id_peca FROM peca WHERE id_maquina = m.id_maquina)
GROUP BY m.id_maquina, m.nome_maquina;

-- 3. Liste todas as manutenções programadas para este mês.
SELECT *
FROM manu_programada
WHERE MONTH(data_programda) = MONTH(CURDATE());

-- 4. Encontre os operadores que estiveram envolvidos na produção de uma peça específica.
SELECT o.id_operador, o.nome, o.especializacao
FROM operadores o
JOIN ordens_prod op ON o.id_operador = id_operador
WHERE op.id_peca = 23;

-- 5. Classifique as peças por peso em ordem decrescente.
SELECT *
FROM peca
ORDER BY weight DESC;

-- 6.  Encontre  a  quantidade  total  de  peças  rejeitadas  em  um  determinado período.
SELECT SUM(id_rejeicao) AS quantidade_total_rejeitada
FROM rejeicoes
WHERE data_rejeicao BETWEEN '01/01/2010' AND '31/12/2010';

-- 7. Liste os fornecedores de matérias-primas em ordem alfabética.
SELECT *
FROM fornecedor
ORDER BY nome_fornecedor ASC;

-- 8. Encontre o número total de peças produzidas por tipo de material.
SELECT material, SUM(quantidade) AS total_de_pecas_por_material
FROM peca
INNER JOIN ordens_prod ON peca.id_peca = ordens_prod.id_peca
GROUP BY material;

-- 9. Selecione as peças que estão abaixo do nível mínimo de estoque.
SELECT *
FROM peca
WHERE estoque_atual < nivel_minimo_estoque;

-- 10. Liste  as  máquinas  que  não  passaram  por  manutenção  nos  últimos  três meses.
SELECT DISTINCT m.*
FROM maquinas m
LEFT JOIN historico_manu hm ON m.id_maquina = hm.fk_equipamento
WHERE hm.data_da_manu IS NULL OR hm.data_da_manu < DATE_SUB(CURDATE(), INTERVAL 3 MONTH);

-- 11. Encontre a média de tempo de produção por tipo de peça.
SELECT
    peca.descricao AS tipo_de_peca,
    AVG(DATEDIFF(data_termino, data_inicio)) AS media_tempo_producao
FROM
    ordens_prod
JOIN
    peca ON ordens_prod.id_peca = peca.id_peca
GROUP BY
    peca.descricao;
    
    
-- 12. Identifique as peças que passaram por inspeção nos últimos sete dias.
SELECT *
FROM inspecao
JOIN peca ON inspecao.fk_peca = peca.id_peca
WHERE data_inspecao BETWEEN CURDATE() - INTERVAL 7 DAY AND CURDATE();

-- 13. Encontre  os  operadores  mais  produtivos  com  base  na  quantidade  de peças produzidas.
SELECT 
    o.id_operador,
    o.nome,
    o.especializacao,
    o.disponibilidade,
    o.historico_prod,
    SUM(op.quantidade) AS total_peças_produzidas
FROM 
    operadores o
JOIN 
    ordens_prod op ON o.id_operador = id_operador
GROUP BY 
    o.id_operador
ORDER BY 
    total_peças_produzidas DESC;
    
-- 14. Liste as peças produzidas em um determinado período com detalhes de data e quantidade.
SELECT op.id_ordem, p.descricao AS descricao_peca, op.data_inicio, op.quantidade
FROM ordens_prod op
JOIN peca p ON op.id_peca = p.id_peca
WHERE op.data_inicio BETWEEN '2023-01-01' AND '2023-12-31';

-- 15. Identifique os fornecedores com as entregas mais frequentes de matérias-primas.
SELECT 
    f.nome_fornecedor,
    COUNT(mp.id_materia) AS entregas_frequentes
FROM 
    fornecedor f
JOIN 
    materia_prima mp ON f.id_fornecedor = mp.fornecedor
GROUP BY 
    f.nome_fornecedor
ORDER BY 
    entregas_frequentes DESC;

-- 16. Encontre o número total de peças produzidas por cada operador.

SELECT
    operadores.id_operador,
    operadores.nome AS nome_operador,
    COALESCE(SUM(ordens_prod.quantidade), 0) AS total_pecas_produzidas
FROM
    operadores
LEFT JOIN ordens_prod ON operadores.id_operador = id_operador
GROUP BY
    operadores.id_operador, operadores.nome;

-- 17. Liste as peças que passaram por inspeção e foram aceitas.
SELECT peca.*
FROM peca
JOIN inspecao ON peca.id_peca = inspecao.fk_peca
JOIN aceitacao ON peca.id_peca = aceitacao.fk_peca_aceita
WHERE inspecao.resultado_inspe = 'Aprovada';

-- 18. Encontre  as  manutenções  programadas  para  as  máquinas  no  próximo mês.

SELECT *
FROM manu_programada
WHERE MONTH(data_programda) = MONTH(CURDATE() + INTERVAL 1 MONTH)
  AND YEAR(data_programda) = YEAR(CURDATE());
  
  -- 19. Calcule o custo total das manutenções realizadas no último trimestre.

SELECT 
    SUM(custo_manutencao) AS custo_total_manutencoes
FROM 
    historico_manu
WHERE 
    data_da_manu >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH);
    
-- 20. Identifique  as  peças  produzidas  com  mais  de  10%  de  rejeições  nos últimos dois meses.
SELECT 
    op.id_ordem,
    p.id_peca,
    p.descricao AS descricao_peca,
    op.quantidade,
    r.motivo_rejeicao,
    r.data_rejeicao
FROM 
    ordens_prod op
JOIN 
    rejeicoes r ON op.id_peca = r.fk_peca
JOIN 
    peca p ON op.id_peca = p.id_peca
WHERE 
    r.data_rejeicao >= CURDATE() - INTERVAL 2 MONTH
    AND op.status = 'Concluída'
GROUP BY 
    op.id_ordem, p.id_peca, r.id_rejeicao
HAVING 
    COUNT(r.id_rejeicao) / op.quantidade > 0.1;
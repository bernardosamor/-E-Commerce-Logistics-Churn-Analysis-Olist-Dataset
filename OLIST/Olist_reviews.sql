SELECT * FROM olist_db.olist_order_reviews_dataset;

-- Filtrar as avaliações menores que 3 e entender se o saldo é significativo perante as notas 4 e 5.
SELECT review_score,
COUNT(*) AS avaliações
FROM  olist_db.olist_order_reviews_dataset
GROUP BY review_score
ORDER BY avaliações DESC;

-- Considerando que sujeira nos dados, filtrando apenas notas de 1 a 5 e o quanto cada nota representa do total.
SELECT 
    review_score,
    COUNT(*) AS avaliacoes,
    ROUND(
        (COUNT(*) / (SELECT COUNT(*) FROM olist_db.olist_order_reviews_dataset WHERE review_score BETWEEN 1 AND 5)) * 100, 
        2) AS avaliacoes_percentual
FROM olist_db.olist_order_reviews_dataset
WHERE review_score BETWEEN 1 AND 5
GROUP BY review_score
ORDER BY avaliacoes DESC;

-- Filtrar as notas 1 e os comentarios para entender se o problema é qualidade do produto ou logística
SELECT
	review_score AS avaliação,
    review_comment_message AS comentario
FROM olist_db.olist_order_reviews_dataset
WHERE review_score = 1 
AND review_comment_message IS NOT NULL
AND review_comment_message <> 'null'
AND review_comment_message <> '';
-- Problema : muitas linhas para avaliar

-- Filtrando quantos comentários existem dentro da nota relacionados a logistica e qualidade
SELECT 
    COUNT(*) AS total_comentarios_nota_1,
    
    -- Contando quantas reclamações mencionam problemas de LOGÍSTICA
    SUM(CASE WHEN review_comment_message LIKE '%atraso%' 
               OR review_comment_message LIKE '%demor%'
               OR review_comment_message LIKE '%não chegou%'
               OR review_comment_message LIKE '%prazo%'
               OR review_comment_message LIKE '%entreg%' THEN 1 ELSE 0 END) AS problemas_logistica,
               
    -- Contando quantas reclamações mencionam problemas de QUALIDADE/PRODUTO
    SUM(CASE WHEN review_score = 1 AND (
                  review_comment_message LIKE '%defeito%' 
               OR review_comment_message LIKE '%quebrado%'
               OR review_comment_message LIKE '%errado%'
               OR review_comment_message LIKE '%gato por lebre%'
               OR review_comment_message LIKE '%ruim%'
               OR review_comment_message LIKE '%péssimo%'
    ) THEN 1 ELSE 0 END) AS problemas_qualidade

FROM olist_db.olist_order_reviews_dataset
WHERE review_score = 1 
  AND review_comment_message IS NOT NULL        
  AND review_comment_message <> 'null';
	
-- 5765 comentários de 18590 avaliações totais, reportando problemas por parte do provedor. Aqui filtrei que pelo menos 31% das avalições nota 1 são por parte do provedor.


# 🛒 E-Commerce Logistics & Churn Analysis | Olist Dataset

![Power BI](https://img.shields.io/badge/Power_BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![MySQL](https://img.shields.io/badge/MySQL-00000F?style=for-the-badge&logo=mysql&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-CC292B?style=for-the-badge&logo=SQL&logoColor=white)
![DAX](https://img.shields.io/badge/DAX-Yellow?style=for-the-badge)

## 📌 Visão Geral do Projeto

Este projeto consiste em um **estudo de caso completo de Business Intelligence e Analytics** realizado sobre a base de dados pública do e-commerce Olist. 

O objetivo principal foi mapear **gargalos operacionais de logística**, mensurar o impacto das entregas fora do prazo na satisfação do cliente (*NPS/Reviews*) e calcular a **destruição de Lifetime Value (LTV)** por meio do *Churn* definitivo de clientes impactados.

---

## 💡 Problema de Negócio

No mapeamento de gatilhos de baixa *performance* da base de dados, foi reparado um alto volume de avaliações nota 1. Estas avaliações foram ligadas a comentários de logística da empresa, principalmente de atraso nas entregas das mercadorias. Entregar com atraso causa prejuízos financeiros imediatos (como retenção de faturamento ou reembolsos). No entanto, o verdadeiro custo invisível de uma falha logística é a perda da recorrência de compra.

## 🧠 Hipóteses que guiaram o projeto

* ** Status de vendas em que contrariavam o sucesso (canceladas, indisponível e afins), correspondem a um relevante faturamento não concretizado.
   * ** Resultado: ❌ Refutado** Faturamento referente a vendas canceladas e indisponíveis somadas chega a apenas 1,68% do faturamento total da empresa.
* ** Haveria formas de pagamento em que poderiam ocasionar gatilho de cancelamento pela necessidade de se realizar o processo manualmente (EX: boleto).
   * ** Resultado: ❌ Refutado** Boleto representa 19,9% das transações totais porém apenas 15,2% das transações com status cancelado. Por outro lado, o **voucher** representa 3,9% das transações totais e 15,04% das transações canceladas. 

## 📈 Impacto de Negócio
 **Insight Crítico:** O atraso na entrega do produto referente ao prazo pré-estabelecido é fatal para uma empresa de entregas, mostrando que 97,58% dos compradores optam por outros serviços após terem suas entregas atrasadas, causando um impacto financeiro muito significativo, e neste caso, colocando um montante retido em atrasos, de R$ 985,82 mil, em risco.

---

## 🛠️ Tecnologias & Ferramentas Utilizadas

- **Linguagens:** MySQL.
- **RoadMap do Projeto:**
  - * Modelagem e limpeza de dados relacionais.
  - * Consultas avançadas (CTEs, *Subqueries*, *Window Functions* e Agrupamentos) para cálculo de retenção e comportamento de recompra.

- **Linguagem:** Power BI (DAX).
  - * Modelagem de dados em esquema estrela (*Star Schema*).
  - * Criação de métricas e KPIs dinâmicos utilizando **DAX** (Contextos de Filtro e Avaliação).
  - * Design de dashboards interativos com *Tooltips* de apoio, navegação intuitiva e foco em *Data Storytelling*.

* **LLMs & Prompt Engineering:** 
  * Uso de IA aplicada para otimização de queries SQL complexas e aceleração da estruturação das análises de negócio.

---

## 💡 Principais Insights & Resultados

* **🚚 Impacto do Frete na Satisfação:** Buscando entender a natureza da alta proporção de avaliações nota 1 se comparada as outras, tracei a causa até a logística da empresa. **25,04%** de todas as avaliações com Nota 1 na plataforma possuem relação direta com atrasos ou falhas logísticas (em comparação com apenas ~6% associadas a problemas de qualidade do produto).
* **🚚 Discrepância de atraso entre estados da mesma região:** O alto volume de público consumidor ou, principalmente, a proximidade geográficas com HUBs de distribuição não garante pouco ou nenhum atraso. Enquanto estados distribuidores como MG e SP apresentam baixo índices percentuais de atraso, polos vizinhos e com muita demanda como o RJ, tem desempenho consideravelmente piores.
* **📉 Destruição de LTV (Churn Imediato):** Ao analisar o histórico de recompra via SQL, identificou-se que **97,58% dos clientes afetados por entregas em atraso nunca mais voltaram a comprar** na plataforma (*Churn* definitivo).
* **💰 Risco Financeiro:** Mais de **R$ 985 mil** em faturamento ficaram diretamente retidos em pedidos entregues após o prazo estipulado.

---

## 📊 Estrutura do Dashboard (Power BI)

O relatório foi estruturado em visão executiva e detalhada:

1. **Capa**
2. **Visão Geral & Financeira:** Natureza e segregação do faturamento total, percentual de vendas distribuídas por forma de pagamento, transações canceladas por forma de pagamento, representação percentual das avaliações no montante total, distribuição estrutural das avaliações nota 1 em logística e qualidade de produto.
3. **Análise de Logística:** Representação gráfica por UF referente ao impacto no faturamento e de gargalos de entrega do serviço.
4. **Tooltips Personalizados:** Abas ocultas nas quais criei meus tooltips personalizados para as duas principais visualizações do Dashboard.

## 📸 Prints do Projeto.

* ** Visão Geral & Financeira:** 

<img width="1301" height="712" alt="Visão Geral   Financeira" src="https://github.com/user-attachments/assets/1c43cd7f-1566-47c0-95b5-6eab65fc2ea9" />

---

* ** Visão de Logística:** 

<img width="1301" height="738" alt="Visão de Logística" src="https://github.com/user-attachments/assets/66b14d81-b762-4e21-9939-738cff4332ac" />

---

* ** Conclusões:**
<img width="1434" height="806" alt="Resultados" src="https://github.com/user-attachments/assets/6b364c9b-c363-4358-8a24-641127aeb623" />
 

---

## 📁 Estrutura do Repositório

```text
├── sql/
│   ├── Olist.sql       # Limpeza e tratamento inicial
├── Excel/
│   ├── processed/      # CSV exportados diretamente da queries do MySQL
├── dashboard/
│   ├── Olist.pbix      # Arquivo do Power BI
│   ├── Apresentação Diagnóstico Olist.pdf        # Versão compilada em PDF
├── README.md                      # Documentação do projeto

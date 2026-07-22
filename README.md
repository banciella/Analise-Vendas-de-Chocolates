Olá me chamo Felipe Banciella e esse é o meu projeto de Chocolate Data Pipeline

## 📌 Descrição
Este projeto tem como objetivo praticar um pipeline completo de dados:
1. Importação de um dataset bruto em formato CSV : https://www.kaggle.com/datasets/saidaminsaidaxmadov/chocolate-sales/data
2. Limpeza e tratamento dos dados utilizando **Python (Pandas)**.
3. Conversão da coluna de datas para o formato `datetime`.
4. Exportação da tabela final para **SQL Server**, permitindo consultas básicas e avançadas.

## 🛠️ Tecnologias Utilizadas
- Python 3.x
- Pandas
- SQLAlchemy + pyodbc (para integração com SQL Server)
- SQL Server

## 🔄 Fluxo do Projeto

```mermaid
graph LR
    A[CSV] --> B[Pandas-Limpeza/Tratamento ]
    B --> C[Conversão de Tipos]
    C --> D[SQL Server-Tabela Orders]

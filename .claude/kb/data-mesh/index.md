# Data Mesh — Domínio KB

> Organização de dados por domínio de negócio, com dados tratados como produto.
> Domínio conceitual, agnóstico de projeto.

## Quando carregar este domínio

- Organizando catálogo/schemas por domínio de negócio
- Definindo o contrato de um data product (o que ele garante a consumidores)
- Avaliando o que do data mesh faz sentido num time pequeno
- Conciliando mesh (organização lógica) com medalhão (camadas físicas)

## Arquivos

| Arquivo | O que responde |
|---------|----------------|
| [quick-reference.md](quick-reference.md) | Princípios, checklist de data product, anti-padrões |
| [concepts/os-quatro-principios.md](concepts/os-quatro-principios.md) | Domain ownership, data as a product, self-serve, governança federada |
| [concepts/mesh-pragmatico-escala-pequena.md](concepts/mesh-pragmatico-escala-pequena.md) | O que adotar (e ignorar) sendo um time só |
| [patterns/data-product-e-contrato.md](patterns/data-product-e-contrato.md) | Anatomia e contrato de um data product |

## Domínios relacionados

- `arquitetura-medalhao/` — camadas físicas sob os data products
- `databricks-lakeflow/` — Unity Catalog implementa a organização por domínio
- `qualidade-de-dados/` — qualidade declarada é parte do contrato do produto

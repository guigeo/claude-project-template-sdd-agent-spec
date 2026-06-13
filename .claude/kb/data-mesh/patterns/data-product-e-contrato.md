# Data Product e seu Contrato

> **Propósito**: Anatomia de um data product — o que declarar para que consumidores confiem
> **Validado**: 2026-06-10

## Quando usar

- Publicando uma tabela Gold para consumo (dashboard, API, outro domínio)
- Formalizando o que consumidores podem assumir como garantido
- Decidindo o que é interface estável vs detalhe interno do pipeline

## Implementação

```text
Contrato mínimo de um data product (documentar no catálogo):

produto:        gold.vendas.pedidos_por_regiao
dono:           {time/pessoa responsável}
semântica:      pedidos confirmados por região; confirmado = pagamento aprovado
grão:           1 linha = região × mês
schema:         estável; mudanças aditivas anunciadas, breaking = produto novo (v2)
atualização:    mensal, até o dia 5 (SLA)
qualidade:      unicidade da chave 100%; completude de região ≥ 99.9% (medida)
linhagem:       silver.pedidos ← bronze.pedidos_raw
acesso:         leitura pública interna; escrita só pelo pipeline
```

```sql
-- A versão executável do contrato vive no catálogo:
COMMENT ON TABLE gold.pedidos_por_regiao IS
'Pedidos confirmados por região/mês. Grão: região × mês. Dono: data-eng.
 SLA: mensal até dia 5. Breaking changes viram tabela _v2.';
ALTER TABLE gold.pedidos_por_regiao SET TAGS ('domain' = 'vendas', 'tier' = 'product');
```

## Configuração

| Elemento | Regra |
|----------|-------|
| Nome | Estável — refactors internos não mudam o nome do produto |
| Schema | Mudança aditiva ok; breaking change = nova versão, não edição |
| Internals (Bronze/Silver) | NÃO fazem parte do contrato — podem mudar livremente |
| Qualidade | Declarada E medida — promessa sem métrica não é contrato |

## Exemplo de uso

```text
Sinal de contrato funcionando: você reescreve a Silver inteira e
nenhum consumidor da Gold percebe. Sinal de violação: dashboard quebra
porque alguém renomeou uma coluna interna.
```

## Ver também

- [os-quatro-principios](../concepts/os-quatro-principios.md)
- [mesh-pragmatico-escala-pequena](../concepts/mesh-pragmatico-escala-pequena.md)

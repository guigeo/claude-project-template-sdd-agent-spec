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

produto:        gold.cobertura.stations_by_city
dono:           {time/pessoa responsável}
semântica:      antenas ativas por município; ativa = licença vigente na data de corte
grão:           1 linha = município × mês
schema:         estável; mudanças aditivas anunciadas, breaking = produto novo (v2)
atualização:    mensal, até o dia 5 (SLA)
qualidade:      unicidade da chave 100%; completude de município ≥ 99.9% (medida)
linhagem:       silver.licenses ← bronze.anatel_licenses
acesso:         leitura pública interna; escrita só pelo pipeline
```

```sql
-- A versão executável do contrato vive no catálogo:
COMMENT ON TABLE gold.stations_by_city IS
'Antenas ativas por município/mês. Grão: município × mês. Dono: data-eng.
 SLA: mensal até dia 5. Breaking changes viram tabela _v2.';
ALTER TABLE gold.stations_by_city SET TAGS ('domain' = 'cobertura', 'tier' = 'product');
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

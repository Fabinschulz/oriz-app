# Oriz - Gestão Financeira Inteligente

O **Oriz** é um MVP de controle financeiro pessoal desenvolvido com Flutter. O objetivo do projeto é oferecer uma visão clara e rápida da saúde financeira, focando em métricas mensais e distribuição de gastos por categorias.


## Tecnologias e Padrões
Este projeto foi construído seguindo os mais altos padrões de desenvolvimento mobile:

* **Arquitetura:** Clean Architecture (Separação de responsabilidades).
* **Gerenciamento de Estado:** `ChangeNotifier` com `ListenableBuilder` (Nativo e performático).
* **Princípios:** SOLID, DRY (Don't Repeat Yourself) e KISS (Keep It Simple, Stupid).
* **UI/UX:** Material 3 com design responsivo.

## Estrutura do Projeto
A organização de pastas segue a lógica de camadas para facilitar a manutenção e escalabilidade:

```text
lib/
├── core/           # Constantes, temas e utilitários globais
├── data/           # Implementações de repositórios e fontes de dados (Mocks/SQLite)
├── domain/         # O coração do app: Entidades, Contratos e Casos de Uso
│   ├── entities/   # Modelos de negócio imutáveis
│   ├── enum/       # Categorias e Tipos de transação
│   ├── repositories/# Interfaces (Contratos)
│   └── usecases/   # Lógica de negócio isolada (Cálculos de métricas)
└── presentation/   # Interface do usuário (Telas, Widgets e Controllers)
```

## Funcionalidades do MVP

- [x] **Dashboard Financeiro**: Resumo de entradas, saídas e saldo total.
- [x] **Gráfico de Gastos**: Visualização percentual por categorias (Mercado, Gasolina, etc).
- [x] **Histórico**: Listagem detalhada de transações com ícones intuitivos.
- [ ] **Fluxo de Cadastro**: Adição de novas transações (próxima etapa).

## Como Executar

1. Certifique-se de ter o **Flutter** instalado (versão estável).
2. Clone o repositório.
3. Execute `flutter pub get` para instalar as dependências.
4. Rode o projeto com `flutter run`.

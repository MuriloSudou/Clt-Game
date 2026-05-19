# CLT Game

## Integrantes
- Gabriel Leandro
- Sandro Soares Filho
- Fabio Eduardo de Miranda Lima
- Murilo Sudou Padilha

## Descrição do jogo
O **CLT Game** é um simulador satírico desenvolvido na engine Godot que utiliza o humor e a ironia para retratar a rotina do trabalhador brasileiro. O objetivo do projeto é aplicar conceitos de lógica de programação, design de níveis e diferentes mecânicas de gameplay em um único ecossistema, explorando a versatilidade do desenvolvimento de jogos para transmitir uma crítica social leve e divertida. O jogador deve enfrentar as demandas absurdas do mercado de trabalho em três cenários distintos, lidando com pressões de chefia, tempo e cumprimento de metas.

## Gênero
**Simulador Satírico / Coletânea de Minigames (Arcade)**.
O jogo se enquadra neste gênero pois une o aprendizado técnico a uma narrativa bem-humorada baseada no cotidiano corporativo, alternando drasticamente suas mecânicas centrais (gestão de tarefas, sobrevivência/ação e jogo rítmico) conforme o mapa atual.

## Versão da Godot
**Godot Engine v4.6.1** (Implementado em linguagem GDScript utilizando recursos de manipulação de nós dinâmicos, tweens de interface e processamento físico integrado).

## Como executar o projeto
1. Clone ou baixe este repositório.
2. Abra a Godot Engine (versão 4 ou superior).
3. Clique em "Importar".
4. Selecione o arquivo `project.godot` na raiz do projeto.
5. Abra a cena do menu principal (`main_menu.tscn`).
6. Execute o projeto (F5).

## Branch avaliada
`main`

## Controles
- **Setas do Teclado:** Controlam a movimentação do personagem por todos os mapas e guiam as ações direcionais no duelo musical.
- **Tecla "E":** Tecla de interação usada para bater o ponto, pegar caixas na indústria e realizar as tarefas no mercado.
- **Tecla Espaço / Enter (ui_accept):** Realiza ações específicas como organizar paletes no mercado utilizando a empilhadeira, desferir socos corretivos na indústria ou confirmar interações.
- **Tecla R (Restart):** Reinicia instantaneamente a cena ou nível atual, funcionando inclusive durante estados de pausa ou Game Over.
- **Tecla Esc / P (Pause):** Alterna o estado de congelamento do jogo, ativando uma interface de menu para retornar, reiniciar a fase ou voltar à tela inicial.

## Funcionalidades implementadas
- **Movimentação Bidimensional por Vetores:** Controle fluido do personagem nos eixos X e Y com lógica de deslize automático ao colidir com paredes cenário.
- **Task Management (Mapa 1):** Sistema de metas quantificáveis sob pressão de tempo para recolhimento de resíduos (lixos), reabastecimento de gôndolas e batida de ponto obrigatória.
- **Condução e Encaixe de Carga (Mapa 1):** Lógica para entrar e operar uma empilhadeira mecânica, alterando dinamicamente as colisões do jogador e permitindo prender e soltar paletes físicos do cenário.
- **Ação e Sobrevivência Industrial (Mapa 2):** Mecânica frenética de transporte de cargas com desvio de perigos dinâmicos (serras com física de rebote e canos que disparam pregos).
- **Manutenção Urgente sob Pane (Mapa 2):** Sistema de ciclo de quebra de maquinários que entram em curto-circuito e exigem socos físicos (impactos de hitbox) dentro de um limite de tempo para evitar a explosão da fase.
- **Efeitos de Status e Consumíveis (Mapa 2):** Sistema de bônus por coleta de itens, incluindo café (dobra a velocidade do jogador) e escudos de invencibilidade temporária contra obstáculos perigosos.
- **Inteligência de Perseguição (Mapa 2):** Inimigo (Supervisor) que persegue ativamente o trabalhador para roubar tempo do cronômetro da fase caso consiga alcançá-lo.
- **Furtividade no Escritório (Mapa 3):** Mecânica de tela dupla no monitor da empresa, permitindo alternar instantaneamente entre o jogo Snake (lazer) e uma planilha de Excel falsa (trabalho) para evitar o flagra do chefe.
- **Sistema de Ritmo por BPM (Mapa 3):** Minigame musical calibrado a 140 BPM que instancia notas na tela baseadas em batidas (*beats*), monitorando combo, precisão de acerto (*Perfect, Good, Miss*) e barra de vida reativa.
- **Lógica Geral em GDScript:** Implementação nativa de colisões complexas, sistemas acumuladores de pontuação e transição inteligente de estados de jogo.

## Funcionalidades pendentes
- **Menu de Acessibilidade:** Desenvolvimento de uma interface para remapeamento dinâmico de comandos por parte do usuário e controle individualizado de canais de volume (Master, BGM, SFX).
- **Ajustes de Design de Níveis:** Balanceamento refinado dos tempos de recarga de itens de suporte e expansão do banco de dados de notas (*notes_data*) para músicas adicionais.

## Organização do projeto
O repositório do projeto adota uma divisão modular baseada nos cenários e responsabilidades do sistema:
- `mercado/`
    - `scenes/`: Armazena as estruturas de ambiente do supermercado, menus de pause, seleção de fase e o menu principal (`main_menu.tscn`).
    - `scripts/`: Lógicas de interface das metas de limpeza, reposição de gôndolas e controle cinemático do trabalhador.
- `industria/`
    - Agrupa arquivos de cena e lógicas da fábrica, controle de RigidBody2D para caixas, disparadores de pregos, movimentação de serras e IA do supervisor.
- `escritorio/`
    - `scenes/`: Concentra a cena de duelo musical contra o chefe, a máquina de estado do monitor e a janela do minigame Snake.
    - `art/`: Contém os sprites e texturas 2D pixelados das setas de comando e indicações Visuais.

## Principais scripts
- `principal_escritorio.gd`: Controla o monitor de trabalho no escritório, gerenciando o temporizador de alerta do chefe, a tolerância de reação de 1.5 segundos e a visibilidade das telas de Snake/Excel.
- `jogo_ritmo.gd`: Executa o motor musical a 140 BPM, controlando o spawn de notas por tempo de áudio, cálculo de distância da linha de acerto, punição por *Miss* (-10 de vida) e barra de progresso colorida.
- `jogador_industria.gd`: Gerencia as físicas de movimentação do jogador na fábrica, hitbox de ataque (soco) para mover caixas ou consertar painéis, controle de vidas e temporizadores de buffs.
- `maquina.gd`: Controla o ciclo de pane técnica da máquina industrial, alterando sua modulação de cor por ondas de brilho e validando o recebimento de socos para reativação do motor.
- `supervisor.gd`: Inteligência do inimigo que rastreia os eixos de distância do jogador e manipula o cronômetro do Canvas de interface para aplicar penalidades de tempo.
- `empilhadeira.gd`: Controla a física da máquina de transporte, desativação de colisões internas ao embarcar e sensores de garfo para reparentalização de paletes.

## Assets utilizados
- **Estética Visual (Design 2D Pixelado):** Elementos visuais em pixel art desenhados de forma autoral para reforçar a narrativa sarcástica e o humor do projeto.
- **Efeitos Sonoros (SFX):** Efeitos sonoros de feedback imediato de ações, como sons de socos, batidas, alarmes de curto-circuito de máquinas, impacto de eletricidade e sucesso ao depositar itens em lixeiras.
- **Trilhas Musicais (BGM):** Arquivos de áudio em loop para ambientação de menus e faixas musicais específicas estruturadas com batidas exatas para sincronização com o sistema rítmico do escritório.

## Histórico de desenvolvimento
- Implementação da lógica de movimentação bidimensional com deslize em barreiras físicas.
- Criação do sistema de interações contextuais com a tecla "E" e mecânica de carregar itens via herança de nós (*reparent*).
- Desenvolvimento do Mapa 1 (Mercado) integrando tarefas de reposição e condução física de empilhadeira.
- Criação do Mapa 2 (Indústria) focado em sobrevivência, desvio de obstáculos físicos, e IA de perseguição do Supervisor.
- Implementação do sistema de manutenção de máquinas sob pani rítmica com socos corretivos.
- Desenvolvimento da interface de monitor do escritório com mecânica de furtividade (Snake vs Fake Excel).
- Criação do minigame de duelo rítmico a 140 BPM integrado ao sistema de barra de saúde reativa por cor.
- Polimento de menus principais, botões animados com Tweens de escala e caixas de diálogos satíricas ("Pedir a Conta" / "Atestado").

## Problemas conhecidos
- **Verificação por String de Nome:** Determinados scripts ainda realizam checagem de colisão comparando diretamente strings de texto (como `body.name == "Jogador"`), o que pode quebrar sistemas caso os nós da árvore de cenas sejam renomeados no editor. *Melhoria planejada:* Substituir todas as checagens nominais restantes por validações baseadas na detecção de métodos específicos (`body.has_method("tomar_dano")`) ou pelo sistema nativo de Grupos e máscaras de colisão da Godot Engine.


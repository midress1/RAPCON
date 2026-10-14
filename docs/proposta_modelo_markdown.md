# Proposta de Trabalho

# A geração de pontos cotados com perturbação estocástica ao longo de uma diretriz geométrica sobre um Modelo Digital de Terreno (MDT).
ENG01066 - Projetos Integrados III - Turma A - 2026/2
*Prof.** **Felipe** **Pinto** **da** **Motta** **Quevedo Prof. Felipe Schaedler de Almeida*
Grupo 7:

00342774 – Milena Dressler Medeiros
00578634 - Vítor Gorski Salbego

## Identificação do problema

A geração de pontos cotados com perturbação estocástica ao longo de uma diretriz geométrica sobre um Modelo Digital de Terreno (MDT).
•(i) Contexto: Projetos de infraestrutura rodoviária e geotecnia no AutoCAD Civil 3D demandam amostragem de terreno em faixas laterais (offset) como simulação de sondagens expeditas, dispersão de vegetação e obstáculos em faixas de domínio, modelagem de incertezas topográficas ou testes de interpolação de superfícies Nesta Proposta, iremos focar nos problemas com superfícies topográficas.
•(ii) Situação atual: Tradicionalmente, o projetista precisa criar alinhamentos secundários, gerar linhas de amostragem (sample lines), offset manual de polilinhas ou inserir pontos (COGO Points/blocos) individualmente com comandos manuais de CAD.
•(iii) Dificuldade principal: Processo repetitivo, lento e estritamente determinístico quando feito manualmente; a inserção manual não introduz dispersão estatística de forma controlada nem projeta automaticamente as cotas em lote a partir da malha triangular da superfície.
•(iv) Impacto: Redução substancial de tempo de modelagem (dezenas de minutos para poucos segundos), eliminação de erros humanos de digitação de coordenadas e viabilização de análises de sensibilidade ou simulações estocásticas em projetos viários.

### Objetivo da ferramenta

**Objetivo principal**: Automatizar a amostragem e a inserção de entidades de pontos 3D no AutoCAD/Civil 3D a uma distância perpendicular definida a partir dos vértices de uma polilinha base (no caso do estudo, o eixo de uma rodovia), aplicando ruído aleatório em Xe Ye interpolando a cota Z na superfície topográfica.
**Objetivo secundário**: Evitar interrupções de execução por meio de tratamento de erros quando coordenadas caem fora dos limites da malha (boundary do MDT) e empregar late binding para mitigar incompatibilidades de versão da API COM do Civil 3D.
**Uso esperado da solução**: Execução via linha de comando/painel VBA dentro do Civil 3D para apoiar estudos conceituais de traçado, simulação de pontos de ensaio de campo e geração rápida de dados auxiliares de projeto.

### Público-alvo
A proposta tem caráter:
Educacional
Profissional
Social/comunitário
Pesquisa e desenvolvimento
Outro:

A solução será voltada para:

Profissionais da área;
Estudantes;
Docentes;
Empreendedores/empresa;
Comunidade ou instituição externa;
Outro:

Justificativa:

A solução reduz o trabalho braçal de desenho geométrico em escritórios de projeto rodoviário e serve como base didática para o ensino de automação CAD/BIM e integração de modelos digitais de elevação com programação aplicada à infraestrutura.

## Formulação conceitual
**Hipóteses **(Premissas adotadas)

Geometria de referência: A polilinha de entrada atua como o eixo ou plano base e é interpretada como uma sequência de segmentos retos entre os vértices.
Sentido do traçado: O estaqueamento ou avanço da rotina respeita estritamente a ordem de criação dos vértices da polilinha.
Superfície: Assume-se que o Modelo Digital de Terreno (MDT) do Civil 3D seja uma malha contínua dentro do seu contorno delimitador (boundary)

**	****Delimitações:** O cálculo perpendicular é efetuado pontualmente em cada vértice tomando como vetor de direção o segmento que parte para o próximo vértice (ou o segmento anterior, no caso do último vértice); a perturbação aplica uma distribuição uniforme independente para as coordenadas e .

**Limitações:** Em curvas circulares/espirais discretizadas com poucos vértices, a perpendicular pode não representar a bissetriz exata do ângulo do vértice; pontos cujas coordenadas perturbadas ultrapassem o contorno do MDT são desconsiderados (Err.Number <> 0); os pontos gerados são primitivas nativas do AutoCAD (AcadPoint), e não objetos paramétricos AeccPoint/CogoPoint.

**Embasamento teórico:** Geometria descritiva e analítica (rotação ortogonal de vetores por ), números pseudoaleatórios com distribuição uniforme () e modelos de elevação TIN com interpolação de cotas via plano do triângulo envolvente.

### Parâmetros do problema

### Cálculos
O algoritmo processa sequencialmente cada vértice da polilinha:
**Azimute/Ângulo do segmento base (****):**

*(No último vértice, adota-se o vetor do segmento anterior: **)*.
**Ângulo da seção transversal (****):**

**Coordenadas nominais do offset (****):**

**Perturbação aleatória uniforme (****):**

**Interpolação de elevação e validação:**

Se a consulta retornar sucesso, o ponto 3D é persistido no desenho
### Resultados
•	Entidades gráficas: Pontos tridimensionais (AcDbPoint) inseridos diretamente no ModelSpace do desenho ativo.
•	Retorno ao usuário: Caixa de diálogo final informativa (MsgBox do tipo vbInformation) exibindo o total de pontos inseridos com sucesso sobre a malha.

## Estratégia de implementação
Classes e Objetos utilizados:
AcadLWPolyline: Extração de coordenadas bidimensionais dos vértices (Coordinates).
AcadUtility: Captura de inputs de usuário (GetEntity, GetReal, GetKeyword, AngleFromXAxis).
AcadModelSpace: Criação e inserção de geometrias no banco de dados do DWG (AddPoint).
oSurface (Late Binding do Civil 3D): Invoca dinamicamente o método COM FindElevationAtXY(x, y) sem necessidade de fixar referências às bibliotecas de tipos de uma versão específica do software (AeccXLand.tlb).
Módulos: Módulo de código padrão VBA (Module1.bas).
Dependências / Bibliotecas:
AutoCAD Type Library (acax*.tlb / biblioteca COM padrão do host).
AutoCAD Civil 3D VBA Enabler instalado no ambiente de execução.

### Estratégia de Verificação
#### Testes
1.	Polilinha em linha reta (2 vértices): Validar se o offset lateral respeita a distância teórica e se o sinal da perpendicular corresponde ao lado selecionado.
2.	Teste de contorno (fora do MDT): Executar a rotina fornecendo distância de offset maior que o limite da superfície para verificar se a rotina ignora os pontos externos sem interromper o código com erro de execução.
3.	Teste de dispersão nula: Rodar com randFactor = 0 para confirmar se as coordenadas resultantes casam estritamente com o offset geométrico analítico.
4.	Teste com tipos inválidos: Selecionar linhas, arcos ou blocos no primeiro prompt para validar o bloqueio do TypeOf oEnt Is AcadLWPolyline.
#### Exemplos
Exemplo 1 (Simulação de ensaios geotécnicos): Seleção do eixo de um traçado rodoviário de 5 km, offset de 15 m (faixa de domínio à direita), fator de aleatoriedade de 2,5 m para locar pontos preliminares de sondagem a trado ao longo do terreno natural.help.autodesk
Exemplo 2 (Validação de MDT): Geração de malha de pontos amostrais a 5 m à esquerda de uma valeta de drenagem para confrontar cotas de projeto com uma nova superfície LiDAR pós-obra.

| Parâmetro | Tipo de Dado | Modo de Entrada | Descrição |
| --- | --- | --- | --- |
| Polilinha base | Entidade CAD (AcadLWPolyline) | Seleção em tela (GetEntity) | Geometria plana de referência para os vértices |
| Distância perpendicular | Numérico real (Double) | Linha de comando (GetReal) | Offset nominal em relação ao alinhamento. |
| Lado | Palavra-chave (String) | Teclado/Opções (GetKeyword) | Esquerda () ou Direita (). |
| Fator de aleatoriedade | Numérico real (Double) | Linha de comando (GetReal) | Amplitude máxima de variação ( valor em metros). |
| Superfície MDT | Entidade Civil 3D (AeccSurface / TinSurface) | Seleção em tela (GetEntity) | Malha topográfica para extração do . |

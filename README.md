# Detector de Erros JABOT
O Detector de Erros JABOT é uma ferramenta de controle de qualidade para coleções gerenciadas pelo Jabot. É um script em R que identifica uma série de inconsistências e erros em potencial nos registros exportados do Jabot. Dentre as mais de 70 verificações realizadas por este código estão:

- Datas inconsistentes
- Herbário de origem fora do Index Herbariorum
- Número de coleta duplicado
- Taxonomia em desacordo com o Flora e Funga do Brasil e com o World Checklist of Vascular Plants (taxa e autores)
- Gêneros duplicados em famílias diferentes
- Coordenadas incompatíveis com país, estado, município ou unidade de conservação e distância das coordenadas até o município indicado
- Mapas com plot dos registros com maior probabilidade de erros espaciais

O próprio Jabot tem um sistema que verifica inconsistências, mas ele padece de algumas limitações. Esta ferramenta expande a gama de verificações e pode ser muito útil para encontrar uma ampla variedade de problemas. Este script opera apenas sobre a planilha de registros exportados, portanto, sua funcionalidade está restrita a encontrar as inconsistências, não a corrigi-las. Uma vez que um erro seja detectado, o ideal é examinar a exsicata e editar o registro manualmente, se necessário.

O input principal deste script é o arquivo .csv padrão com os registros exportados do JABOT, mas também são necessários outros arquivos para conduzir parte dos testes. Alguns desses arquivos são muito pesados para subir no GitHub, então optei por não disponibilizar a maioria deles, mas deixei pronta a estrutura de pastas e forneço os links por onde esses arquivos podem ser baixados.


## Como utilizar
1. Clone ou baixe este repositório
2. Exporte todos os registros da coleção que você deseja verificar
   - Selecione a coleção e clique em "Consultar". Certifique-se de que todos os outros campos de pesquisa estejam vazios.
   - Role até o final da página. Clique em "Exportar" e depois em CSV (Padrão)
   - Salve o arquivo "planilhapadrao.csv" na mesma pasta do script
3. Baixe os arquivos auxiliares pelos links indicados (verifique se existem versões mais atualizadas)
   - eparties-herbarium-04222026.csv  https://sweetgum.nybg.org/science/ih/
   - RELATORIO_DTB_BRASIL_2025_MUNICIPIOS.ods  https://www.ibge.gov.br/geociencias/organizacao-do-territorio/estrutura-territorial/23701-divisao-territorial-brasileira.html?=&t=downloads&utm_source=landing&utm_medium=explica&utm_campaign=codmun
   - taxon.txt  https://ipt.jbrj.gov.br/jbrj/resource?r=lista_especies_flora_brasil
   - BR_Municipios_2025.shp e BR_Pais_2025.shp https://www.ibge.gov.br/geociencias/organizacao-do-territorio/malhas-territoriais/15774-malhas.html
   - wcvp_names.csv  https://sftp.kew.org/pub/data-repositories/WCVP/
4. Salve cada arquivo na pasta adequada conforme indicado nos demais arquivos READ.ME
5. Abra o script Detector_de_Erros_JABOT_GitHub.R no RStudio
6. Verifique se todos os pacotes necessários estão instalados
7. Selecione tudo (Crtl+A) e rode (CTRL+R)

O script precisa de aproximadamente 10 minutos para terminar de rodar.

## Estrutura
Cada verificação feita por este script gera um objeto da classe data.frame com todos os registros que reprovaram no teste. Todos os objetos de resultado de teste têm nomes descritivos em letras maiúsculas. Em alguns casos, o objeto de resultado do teste tem colunas adicionais que não existem na planilha original ou colunas em uma ordem diferente. Objetos nomeados com letras minúsculas são objetos criados para facilitar a consulta a informações e a realização de testes, mas não armazenam o resultado de nenhuma verificação. Por fim, para alguns testes, a reprovação de um registro implica a existência de um erro, e, portanto, a necessidade de correção. Para outros, a reprovação indica apenas um erro em potencial, de modo que nem todos os registros reprovados em testes devem passar por algum tipo de edição. O arquivos .qmd e .html trazem explicações mais detalhadas sobre alguns testes.

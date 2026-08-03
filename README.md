# Detector de Erros JABOT
O Detector de Erros JABOT é uma ferramenta de controle de qualidade para coleções gerenciadas pelo JABOT. É um script em R que identifica uma série de inconsistências e erros em potencial nos registros exportados do Jabot. Dentre as mais de 70 verificações realizadas por este código estão:

> Datas inconsistentes
> Herbário de origem fora do Index Herbariorum
> Número de coleta duplicado
> Taxonomia em desacordo com o Flora e Funga do Brasil e com o World Checklist of Vascular Plants (taxa e autores)
> Gêneros duplicados em famílias diferentes
> Coordenadas incompatíveis com país, estado, município ou unidade de conservação e distância das coordenadas até o município indicado
> Mapas com plot dos registros com maior probabilidade de erros espaciais

O próprio Jabot tem um sistema que verifica inconsistências, mas ele padece de algumas limitações. Esta ferramenta expande a gama de verificações e pode ser muito útil para encontrar uma ampla variedade de problemas. Este script opera apenas sobre a planilha de registros exportados, de modo sua funcionalidade está restrita a encontrar as inconsistências, não a corrigi-las. Uma vez que um erro seja detectado, o ideal é examinar a exsicata e editar o registro manualmente, se necessário.

O input principal deste script é o arquivo .csv padrão com os registros exportados do JABOT, mas também são necessários outros arquivos para conduzir parte dos testes. Alguns desses arquivos são muito pesados para subir no GitHub, então optei por não disponibilizar a maioria deles, mas deixei pronta a estrutura de pastas e forneço os links por onde esses arquivos podem ser baixados. A introdução do arquivo Detector_de_Erros_Jabot_GitHub.qmd contém mais informações sobre a estrutura do código e sobre os testes.

## Links úteis
Index Herbariorum: https://sweetgum.nybg.org/science/ih/

Lista de Municípios Brasileiros: https://www.ibge.gov.br/geociencias/organizacao-do-territorio/estrutura-territorial/23701-divisao-territorial-brasileira.html?=&t=downloads&utm_source=landing&utm_medium=explica&utm_campaign=codmun

Reflora: https://ipt.jbrj.gov.br/jbrj/resource?r=lista_especies_flora_brasil

Sistema de Consulta JABOT: https://ibge.jbrj.gov.br/v2/consultainterna.php?jb=1a532553c8771a765adaeead52ffd5e07541b9a4

Shapefiles do Território Nacional e Municípios: https://www.ibge.gov.br/geociencias/organizacao-do-territorio/malhas-territoriais/15774-malhas.html

Shapefiles das Unidades de Conservação: https://dados.mma.gov.br/dataset/unidadesdeconservacao

World Checklist of Vascular Plants: https://sftp.kew.org/pub/data-repositories/WCVP/

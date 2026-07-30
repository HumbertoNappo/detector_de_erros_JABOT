# Detector de Erros JABOT
Este script em R identifica uma série de inconsistências e erros em potencial nos registros exportados do Jabot. O próprio Jabot tem um sistema que verifica inconsistências nos registros, mas ele padece de algumas limitações. Esta ferramenta expande as verificações feitas sobre os registros e pode ser muito útil para encontrar uma ampla variedade de problemas nos registros. Este script opera apenas sobre a planilha de registros exportados, de modo sua funcionalidade está restrita a encontrar as inconsistências, não a corrigi-las. Uma vez que um erro seja detectado, o ideal é examinar a exsicata e editar o registro manualmente, se necessário.

O input principal deste script é o arquivo .csv padrão com os registros exportados do JABOT, mas também são necessários outros arquivos para conduzir parte dos testes. Alguns desses arquivos são muito pesados para subir no GitHub, então optei por não disponibilizar nenhum deles, mas deixei pronta a estrutura de pastas e forneço os links por onde esses arquivos podem ser baixados. A introdução do arquivo Detector_de_Erros_Jabot_GitHub.qmd contém mais informações sobre a estrutura do código.

## Links úteis
Sistema de Consulta JABOT: https://ibge.jbrj.gov.br/v2/consultainterna.php?jb=1a532553c8771a765adaeead52ffd5e07541b9a4

Reflora: https://ipt.jbrj.gov.br/jbrj/resource?r=lista_especies_flora_brasil

World Checklist of Vascular Plants: https://sftp.kew.org/pub/data-repositories/WCVP/

Shapefiles do Território Nacional e Municípios: https://www.ibge.gov.br/geociencias/organizacao-do-territorio/malhas-territoriais/15774-malhas.html

Shapefiles das Unidades de Conservação: https://dados.mma.gov.br/dataset/unidadesdeconservacao

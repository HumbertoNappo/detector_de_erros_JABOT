# Preparação

## Carrega Pacotes


library(CoordinateCleaner)
library(countrycode)
library(data.table)
library(geosphere)
library(measurements)
library(readODS)
library(readr)
library(rnaturalearth)
library(rnaturalearthdata)
library(rstudioapi)
library(sf)
library(tidyverse)


## Carrega Dados


# Define a pasta deste script como working directory
setwd(dirname(getActiveDocumentContext()$path))


# Carrega planilha completa do Jabot
herbario_total <- read.csv("planilhapadrao.csv", sep = ";")

# Testes

## Dados de Coleta

### Ano de coleta anterior a 1760



# Ano de coleta anterior a 1760
ANO_COL_MENOR_QUE_1760 <- herbario_total %>%
  filter(collyy < 1760)


### Ano de determinação anterior a 1760


# Ano de determinação anterior a 1760
ANO_DET_MENOR_QUE_1760 <- herbario_total %>%
  filter(., detyy < 1760)


### Ano de coleta posterior ao atual


# Ano de coleta posterior ao atual
ANO_COL_POSTERIOR_AO_ATUAL <- herbario_total %>%
  filter(., collyy > year(Sys.Date()))


### Ano de determinação posterior ao atual


# Ano de determinação posterior ao atual
ANO_DET_POSTERIOR_AO_ATUAL <- herbario_total %>%
  filter(., detyy > year(Sys.Date()))


### Ano de coleta com número de dígitos diferente de 4


# Ano de coleta com número de dígitos diferente de 4
ANO_COL_DIFERENTE_DE_4_DIGITOS <- herbario_total %>%
  filter(., nchar(collyy) != 4)


### Ano de determinação com número de dígitos diferente de 4


# Ano de determinação com número de dígitos diferente de 4
ANO_DET_DIFERENTE_DE_4_DIGITOS <- herbario_total %>%
  filter(., nchar(detyy) != 4)


### Ano de coleta vazio


# Ano de coleta vazio
ANO_VAZIO <- herbario_total %>%
  filter(., is.na(collyy) == TRUE | collyy == "")


### Mês de coleta inválido


MES_COLETA_INVALIDO <- herbario_total %>%
  filter(., is.na(collmm) == FALSE & !(collmm %in% c(1:12)))


### Mês de determinação inválido


MES_DET_INVALIDO <- herbario_total %>%
  filter(., is.na(detmm) == FALSE & !(detmm %in% c(1:12)))


### Dia de coleta inválido


DIA_COLETA_INVALIDO <- herbario_total %>%
  filter(., is.na(colldd) == FALSE & !(colldd %in% c(1:31)))


### Dia de determinação inválido


DIA_DET_INVALIDO <- herbario_total %>%
  filter(., is.na(detdd) == FALSE & !(detdd %in% c(1:31)))


### Dia de coleta sem mês


DIA_COLETA_SEM_MES <- herbario_total %>%
  filter(., is.na(collmm) == TRUE & is.na(colldd) == FALSE)


### Dia de determinação sem mês


DIA_DET_SEM_MES <- herbario_total %>%
  filter(., is.na(detmm) == TRUE & is.na(detdd) == FALSE)


### Data de determinação inválida



herbario_datas <- herbario_total %>%
  mutate(., data_coleta = paste(collyy, collmm, colldd, sep = "-")) %>%
  mutate(., data_determinacao = paste(detyy, detmm, detdd, sep = "-"))

data_det_inv <- grep("NA", herbario_datas$data_determinacao)

DATA_DET_INVALIDA <- herbario_datas[-c(data_det_inv),] %>%
  mutate(., data_determinacao = as.Date(data_determinacao, format = "%Y-%m-%d")) %>%
  filter(., is.na(data_determinacao) == TRUE)


### Data de coleta inválida


herbario_datas <- herbario_total %>%
  mutate(., data_coleta = paste(collyy, collmm, colldd, sep = "-")) %>%
  mutate(., data_determinacao = paste(detyy, detmm, detdd, sep = "-"))

data_col_inv <- grep("NA", herbario_datas$data_coleta)

DATA_COLETA_INVALIDA <- herbario_datas[-c(data_col_inv),] %>%
  mutate(., data_coleta = as.Date(data_coleta, format = "%Y-%m-%d")) %>%
  filter(., is.na(data_coleta) == TRUE)


### Ano/dia de coleta posterior ao ano/dia de identificação


# Ano de coleta posterior ao ano de identificação
ANO_COLETA_APOS_ANO_DETERMINACAO <- herbario_total %>%
  filter(., collyy > detyy)

# Dia de coleta posteiror ao dia de identificação
DIA_COLETA_APOS_DIA_DET <- herbario_total %>%
  mutate(., data_coleta = as.Date(with(., paste(collyy, collmm, colldd, sep = "-")),
                                  format = "%Y-%m-%d")) %>%
  mutate(., data_det = as.Date(with(., paste(detyy, detmm, detdd, sep = "-")),
                               format = "%Y-%m-%d")) %>%
  filter(., data_coleta > data_det)


### Número de tombo duplicado


# Número de tombo duplicado
TOMBO_DUPLICADO <- herbario_total %>%
  filter(., duplicated(herbario_total$codbarras) == TRUE)


### Herbário de origem vazio


# Herbário de origem vazio
HERBARIO_VAZIO <- herbario_total %>%
  filter(., siglacolbotorigem == "")


### Nome do determinador com ponto (.)


# Nome do determinador com ponto (.)
DETERMINADOR_COM_PONTO <- herbario_total %>%
  filter(., grepl("\\.", herbario_total$detby) == TRUE)


### Nome do coletor principal com ponto (.)


# Nome do coletor principal com ponto (.)
COLETOR_COM_PONTO_1 <- herbario_total %>%
  filter(., grepl("\\.", herbario_total$collector) == TRUE)


### Nome dos coletores secundários com ponto (.)


# Nome dos coletores secundários com ponto (.)
COLETOR_COM_PONTO_2 <- herbario_total %>%
  filter(., grepl("\\.", herbario_total$addcoll) == TRUE &
           grepl("et al", herbario_total$addcoll) == FALSE)


### et al. escrito errado


# et al. escrito errado
ET_AL_ERRADO <- herbario_total %>%
  filter(., grepl("et. al", herbario_total$addcoll) == TRUE |
           grepl("et al$", herbario_total$addcoll) == TRUE |
           grepl("etal", herbario_total$addcoll) == TRUE)



### Sem coletor


# Sem coletor
SEM_COLETOR <- herbario_total %>%
  filter(., is.na(collector) == TRUE)


### Coletor ativo por mais de 50 anos


# Coletor ativo por mais de 50 anos
COLETOR_50_ANOS <- herbario_total %>%
  filter(is.na(collyy) == FALSE) %>%
  group_by(collector) %>%
  filter(max(collyy, na.rm = TRUE) - min(collyy, na.rm = TRUE) > 50) %>%
  ungroup() %>%
  select(numtombo, collector, number, collyy) %>%
  arrange(collector, collyy)


### Sem número de coleta


# Sem número de coleta
SEM_NUMERO_DE_COLETA <- herbario_total %>%
  filter(., is.na(number) == TRUE)


### Número de coleta duplicado


# Número de coleta duplicado
NUMERO_DE_COLETA_DUPLICADO <- herbario_total %>%
  group_by(collector, number) %>%
  filter(n() > 1) %>%
  ungroup() %>%
  filter(., !grepl("s.n", number)) %>%
  arrange(collector, number) %>%
  select(codbarras, numtombo, collector, number, everything())


### Número de coleta igual número de tombo


# Número de coleta igual número de tombo
NUM_COLETA_IGUAL_TOMBO <- herbario_total %>%
  filter(., numtombo == number) %>%
  select(codbarras, numtombo, collector, number, everything())


### Sem altitude


# Sem altitude
ALTITUDE_VAZIO <- herbario_total %>%
  filter(., altprof == "" | is.na(altprof) == TRUE)


### Altitude menor que 0


# Altitude menor que 0
ALTITUDE_MENOR_QUE_0 <- herbario_total %>%
  mutate(., altprof = as.numeric(altprof)) %>%
  filter(., altprof < 0)


### Altitude maior que o Everest


ALTITUDE_MAIOR_QUE_EVEREST <- herbario_total %>%
  mutate(., altprof = as.numeric(altprof)) %>%
  filter(., altprof > 8849)


### Sem unidade de medida de altitude


# Sem nidade de medidade de altitude
SEM_UNIDADE_ALTITUDE <- herbario_total %>%
  filter(., unidmedaltprof == "" & altprof != "")


### Unidade de medida de altitude diferente de metro


# Unidade de altitude diferente de metros
ALTITUDE_EM_OUTRA_UNIDADE <- herbario_total %>%
  filter(., unidmedaltprof != "m." & altprof != "")


### Erro na altitude


# Erro na altura
altitude_errada <- grep("[[:alpha:]]| ", herbario_total$altprof)

ERRO_NA_ALTITUDE <- herbario_total[c(altitude_errada),] %>%
  filter(., altprof != "")


### Altura menor ou igual a 0


# Altura menor ou igual a 0
ALTURA_0_OU_MENOR <- herbario_total %>%
  filter(., altura != "" & as.numeric(altura) <= 0)


### Altura maior que a da árvore mais alta do mundo


# Altura maior que a da árvore mais alta do mundo
ALTA_DEMAIS_M <- herbario_total %>%
  filter(., as.numeric(altura) > 116 & unidmedaltura == "m.")


### Altura maior ou igual a 200 cm


# Altura maior que 200 cm
ALTA_DEMAIS_CM <- herbario_total %>%
  filter(., as.numeric(altura) > 200 & unidmedaltura == "cm.")


### Sem unidade de medida de altura


# Sem unidade de medidade de altura
SEM_UNIDADE_ALTURA <- herbario_total %>%
  filter(., unidmedaltura == "" & altura != "")


### Hábito e altura incompatíveis


# Hábito e altura incompatíveis
HABITO_ALTURA_INCOMPATIVEL <- herbario_total %>%
  filter((habito == "Erva" & altura > 5 & unidmedaltura == "m.") |
           (habito == "erva" & altura > 5 & unidmedaltura == "m.") |
           (habito == "Herbácea" & altura > 5 & unidmedaltura == "m.") |
           (habito == "Árvore" & altura < 0.5 & unidmedaltura == "m.") |
           (habito == "árvore" & altura < 0.5 & unidmedaltura == "m.") |
           (habito == "Arvoreta" & altura < 0.5 & unidmedaltura == "m.")) %>%
  select(codbarras, numtombo, family, genus, sp1, habito, altura, unidmedaltura, everything())


### Hábito incomum na família


# Hábito incomum na família
habitos_por_familia <- herbario_total %>%
  filter(family != "", habito != "") %>%
  group_by(family, habito) %>%
  summarise(n = n(), .groups = "drop") %>%
  group_by(family) %>%
  mutate(total = sum(n), freq_rel = round((n / total), 2)) %>%
  ungroup() %>%
  arrange(family, desc(n))

HABITO_INCONSISTENTE_COM_FAMILIA <- habitos_por_familia %>%
  filter(freq_rel < 0.1)


### Hábito incomum no gênero


# Hábito incomum no gênero
habitos_por_genero <- herbario_total %>%
  filter(genus != "", habito != "") %>%
  group_by(family, genus, habito) %>%
  summarise(n = n(), .groups = "drop") %>%
  group_by(genus) %>%
  mutate(total = sum(n), freq_rel = round((n / total), 2)) %>%
  ungroup() %>%
  arrange(family, genus, desc(n))

HABITO_INCONSISTENTE_COM_GENERO <- habitos_por_genero %>%
  filter(freq_rel < 0.1)


### Hábito incomum na espécie


# Hábito incomum na espécie
habitos_por_especie <- herbario_total %>%
  filter(sp1 != "", habito != "") %>%
  group_by(family, genus, sp1, habito) %>%
  summarise(n = n(), .groups = "drop") %>%
  group_by(genus, sp1) %>%
  mutate(total = sum(n), freq_rel = round((n / total), 2)) %>%
  ungroup() %>%
  arrange(family, genus, sp1, desc(n))

HABITO_INCONSISTENTE_COM_ESPECIE <- habitos_por_especie %>%
  filter(freq_rel < 0.1)


### Erro na altura


# Erro na altura
altura_errada <- grep("[[:alpha:]]| ", herbario_total$altura)

ERRO_NA_ALTURA <- herbario_total[c(altura_errada),] %>%
  filter(., altura != "")


### Herbário ausente na lista do Index Herbariorum


#Herbário ausente na lista do Index Herbariorum 
herbarios_origem <- as.data.frame(table(herbario_total$siglacolbotorigem))

index_herbariorum <- read.csv("eparties-herbarium-04222026.csv",
                              fileEncoding = "UTF-16LE") # Essa versão parece ter vindo com algum erro no encoding, mas esse parâmetro corrige o problema

HERBARIOS_AUSENTES_IH <- anti_join(herbarios_origem, index_herbariorum,
                                   by = join_by(Var1 == NamOrganisationAcronym))


### Outras verificações

#### Hábito


#Hábito
habito <- as.data.frame(table(herbario_total$habito))


#### Hábitat


#Hábitat
habitat <- as.data.frame(table(herbario_total$habitat))


#### Status de tipo


#Status de tipo
tipos <- as.data.frame(table(herbario_total$typestat))


#### Coletor principal


#Coletor principal
coletores <- as.data.frame(table(herbario_total$collector))


#### Determinador


#Determinador
determinadores <- as.data.frame(table(herbario_total$detby))


## Taxonomia

### Espécies registradas no Jabot


# Espécies registradas no Jabot
especies <- herbario_total %>%
  filter(sp2 == "" | is.na(sp2) == TRUE) %>% # Remove subespécies e variedades
  select(., c( family, genus, sp1, author1)) %>%
  mutate(species = paste(genus, sp1, sep = " "), .before = 2, .keep = "unused") %>%
  distinct() %>%
  filter(species != "" & species != " ") %>%
  arrange(family, species) %>%
  .[grep("[[:alpha:]] [[:alpha:]]", .$species),]


### Família escrita sem o sufixo -aceae


# Família escrita sem o sufixo -aceae
FAMILIA_SEM_ACEAE <- herbario_total %>%
  filter(., grepl("ACEAE$", herbario_total$family) == FALSE)


### Gêneros sem família


# Gêneros sem família
GENERO_SEM_FAMILIA <- herbario_total %>%
  filter(family == "" & genus != "")


### Epítetos específicos sem gênero


# Epítetos específicos sem gênero
EPITETO_SEM_GENERO <- herbario_total %>%
  filter(genus == "" & sp1 != "")


### Gêneros duplicados em diferentes famílias


# Gêneros duplicados em diferentes famílias
GENERO_EM_FAMILIAS_DIFERENTES <- herbario_total %>%
  select(., c(family, genus)) %>%
  unique() %>%
  .[duplicated(.$genus) == TRUE | duplicated(.$genus, fromLast = TRUE) == TRUE,] %>%
  filter(., genus != "") %>%
  arrange(., genus)


### Espécies sem autor


# Espécies sem autor
ESPECIES_SEM_AUTOR <- especies %>%
  filter(., author1 == "" | is.na(author1))


### Espécies com mais de um autor


# Espécies com mais de um autor
ESPECIES_COM_MAIS_DE_UM_AUTOR <- especies[duplicated(especies$species) == TRUE |duplicated(especies$species, fromLast = TRUE) == TRUE,]


### Identifica espécies com nome potencialmente errado


# Identifica espécies com nome potencialmente errado
nomes_especies_jabot <- unique(especies$species)
d <- as.matrix(adist(unique(especies$species))) #Esta linha demora alguns minutos
pares <- which(d <= 3 & lower.tri(d), arr.ind = TRUE)
pares_df <- data.frame(i = pares[,1],
                       j = pares[,2],
                       nome_i = nomes_especies_jabot[pares[,1]],
                       nome_j = nomes_especies_jabot[pares[,2]],
                       dist = d[pares] )

NOMES_QUE_DIFEREM_EM_1_DIGITO <- subset(pares_df, dist == 1) #Alta probabilidade de erro
NOMES_QUE_DIFEREM_EM_2_DIGITOS <- subset(pares_df, dist == 2)#Média probabilidade de erro
NOMES_QUE_DIFEREM_EM_3_DIGITOS <- subset(pares_df, dist == 3)#Baixa probabilidade de erro


### Identifica nomes diferentes dos válidos

#### Comparação com o REFLORA


REFLORA <- read_tsv("dwca-lista_especies_flora_brasil-v393.429/taxon.txt",
                    col_names = TRUE)

# Famílias válidas
familias_validas_REFLORA <- REFLORA %>%
  filter(., taxonomicStatus == "NOME_ACEITO") %>%
  filter(., taxonRank == "FAMILIA") %>%
  select(., c(12:16,21,24))

# Famílias registradas no herbário
familias <- sort(unique(herbario_total$family))

# Famílias ausentes no Reflora
FAMILIAS_AUSENTES_REFLORA <- familias[familias %in% sort(toupper(familias_validas_REFLORA$family)) == FALSE] %>%
  as.data.frame()

# Gêneros válidos
generos_validos_REFLORA <- REFLORA %>%
  filter(., taxonomicStatus == "NOME_ACEITO") %>%
  filter(., taxonRank == "GENERO") %>%
  select(., c(12:17,21,24))

# Gêneros registrados no herbário
generos <- sort(unique(herbario_total$genus))

generos <- herbario_total %>%
  select(family, genus) %>%
  distinct() %>%
  filter(genus != "") %>%
  arrange(family, genus)

# Gêneros ausentes no Reflora
GENEROS_AUSENTES_REFLORA <- generos[generos$genus %in% sort(generos_validos_REFLORA$genus) == FALSE, ] %>%
  as.data.frame()

# Espécies válidas
especies_validas_REFLORA <- REFLORA %>%
  filter(., taxonomicStatus == "NOME_ACEITO") %>%
  filter(., taxonRank == "ESPECIE") %>%
  mutate(., species = paste(genus, specificEpithet, sep = " ")) %>%
  mutate(., author1 = scientificNameAuthorship) %>%
  select(., family, species, author1) %>%
  mutate(family = toupper(family)) %>%
  arrange(family, species)

# Espécies ausentes no Reflora
ESPECIES_AUSENTES_REFLORA <- anti_join(especies[,c(1:2)], especies_validas_REFLORA[,c(1:2)])


##### Sinônimos REFLORA


# Sinônimos segundo a lista do REFLORA
sinonimias_reflora <- REFLORA %>%
  filter(., taxonomicStatus == "SINONIMO") %>%
  filter(., taxonRank == "ESPECIE") %>%
  mutate(., species = paste(genus, specificEpithet, sep = " ")) %>%
  mutate(., author1 = scientificNameAuthorship) %>%
  select(., family, species, author1) %>%
  mutate(family = toupper(family)) %>%
  arrange(family, species)

SINONIMOS_REFLORA <- inner_join(especies[,c(1:2)], sinonimias_reflora[,c(1:2)])


#### Comparação com o World Checklist of Vascular Plants


# Importa nomes do WCVP
WCVP <- fread("wcvp/wcvp_names.csv") %>%
  select("taxon_rank", "taxon_status", "family", "genus", "taxon_name", "taxon_authors")

# Importa nomes do Bryophyte Nomenclator e ajusta nomes das colunas
bryo_nomenclator <- fread("4839627f-55a2-417a-88c8-ef2541ba8f20/Taxon.tsv") %>%
  select("dwc:taxonRank",
         "dwc:taxonomicStatus",
         "dwc:family",
         "dwc:genericName",
         "dwc:specificEpithet",
         "dwc:scientificNameAuthorship") %>%
  rename(taxon_rank = "dwc:taxonRank",
         taxon_status = "dwc:taxonomicStatus",
         family = "dwc:family",
         genus = "dwc:genericName",
         taxon_name = "dwc:specificEpithet",
         taxon_authors = "dwc:scientificNameAuthorship") %>%
  mutate(taxon_rank = str_to_title(taxon_rank),
         taxon_status = str_to_title(taxon_status),
         taxon_name = paste(genus, taxon_name, sep = " ")) %>%
  filter(family != "") %>%
  arrange(family, taxon_name)


WCVP_bryo_nome <- rbind(WCVP, bryo_nomenclator)

# Famílias válidas
familias_validas_WCVP_bryo_nome <- WCVP_bryo_nome  %>%
  filter(taxon_status == "Accepted") %>%
  select(family) %>%
  distinct() %>%
  arrange(family)

# Famílias registradas no herbário
familias <- sort(unique(herbario_total$family))

# Famílias ausentes no WCVP_bryo_nome
FAMILIAS_AUSENTES_WCVP_bryo_nome <- familias[familias %in% sort(toupper(familias_validas_WCVP_bryo_nome$family)) == FALSE] %>%
  as.data.frame()

# Gêneros válidos
generos_validos_WCVP_bryo_nome <- WCVP_bryo_nome  %>%
  filter(taxon_status == "Accepted") %>%
  select(family, genus) %>%
  distinct() %>%
  arrange(family, genus)

# Gêneros registrados no herbário
generos <- sort(unique(herbario_total$genus))

generos <- herbario_total %>%
  select(family, genus) %>%
  distinct() %>%
  filter(genus != "") %>%
  arrange(family, genus)

# Gêneros ausentes no WCVP_bryo_nome
GENEROS_AUSENTES_WCVP_bryo_nome <- generos[generos$genus %in% sort(generos_validos_WCVP_bryo_nome$genus) == FALSE, ] %>%
  as.data.frame()

# Espécies válidas
especies_validas_WCVP_bryo_nome <- WCVP_bryo_nome %>%
  filter(taxon_status == "Accepted") %>%
  filter(., taxon_rank == "Species") %>%
  mutate(., species = taxon_name) %>%
  mutate(., author1 = taxon_authors) %>%
  select(., family, species, author1) %>%
  mutate(family = toupper(family)) %>%
  arrange(family, species)

# Espécies ausentes no WCVP_bryo_nome
ESPECIES_AUSENTES_WCVP_bryo_nome <- anti_join(especies[,c(1:2)], especies_validas_WCVP_bryo_nome[,c(1:2)])

# Famílias ausentes no Reflora e no WCVP_bryo_nome simultaneamente
FAMILIAS_AUSENTES_AMBOS <- intersect(FAMILIAS_AUSENTES_REFLORA, FAMILIAS_AUSENTES_WCVP_bryo_nome)

# Gêneros ausentes no Reflora e no WCVP_bryo_nome simultaneamente
GENEROS_AUSENTES_AMBOS <- intersect(GENEROS_AUSENTES_REFLORA, GENEROS_AUSENTES_WCVP_bryo_nome)

# Espécies ausentes no Reflora e no WCVP simultaneamente
ESPECIES_AUSENTES_AMBOS <- intersect(ESPECIES_AUSENTES_REFLORA, ESPECIES_AUSENTES_WCVP_bryo_nome)

### Identifica autores com nome diferente do Reflora


# Autores diferentes do REFLORA
AUTORES_DIFERENTES_REFLORA <- semi_join(especies, especies_validas_REFLORA,
                                        by = "species") %>%
  rename(autor_herbario = author1) %>%
  left_join(., especies_validas_REFLORA) %>%
  rename(autor_REFLORA = author1) %>%
  filter(autor_herbario != autor_REFLORA)


##### Sinônimos WCVP


# Sinônimos segundo a lista do WCVP
sinonimias_WCVP <- WCVP %>%
  filter(., taxon_status == "Synonym") %>%
  filter(., taxon_rank == "Species") %>%
  mutate(., species = taxon_name) %>%
  mutate(., author1 = taxon_authors) %>%
  select(., family, species, author1) %>%
  mutate(family = toupper(family)) %>%
  arrange(family, species)

SINONIMOS_WCVP <- inner_join(especies[,c(1:2)], sinonimias_WCVP[,c(1:2)])


### Identifica autores com nome diferente do WCVP


# Autores diferentes do WCVP
AUTORES_DIFERENTES_WCVP <- semi_join(especies, especies_validas_WCVP_bryo_nome,
                                     by = "species") %>%
  rename(autor_herbario = author1) %>%
  left_join(., especies_validas_WCVP_bryo_nome) %>%
  rename(autor_WCVP = author1) %>%
  filter(autor_herbario != autor_WCVP)


## Coordenadas Geográficas

### Converte coordenadas em DMS para decimal


# Converte coordenadas em DMS para decimal
latitude_DMS <- paste(herbario_total$lat_grau, herbario_total$lat_min, herbario_total$lat_seg, sep = " ")
latitude_decimal <- conv_unit(latitude_DMS, "deg_min_sec", "dec_deg")

longitude_DMS <- paste(herbario_total$long_grau, herbario_total$long_min, herbario_total$long_seg, sep = " ")
longitude_decimal <- conv_unit(longitude_DMS, "deg_min_sec", "dec_deg")

herbario_coord_decimal <- herbario_total %>%
  mutate(latitude = latitude_decimal, longitude = longitude_decimal) %>%
  mutate(., latitude = ifelse(ns == "S", paste0("-", latitude), latitude)) %>%
  mutate(., longitude = ifelse(ew == "W", paste0("-", longitude), longitude)) %>%
  mutate(., latitude = as.numeric(latitude), longitude = as.numeric(longitude))


### Coordenadas inválidas


# Coordenadas inválidas
COORD_INVALIDAS <- herbario_total %>%
  filter(as.numeric(lat_grau) > 90 | as.numeric(long_grau) > 180 |
           as.numeric(lat_min) >= 60 | as.numeric(long_min) >= 60 | 
           as.numeric(lat_seg) >= 60 | as.numeric(long_seg) >= 60)


### Coordenadas incompletas


# Coordenadas incompletas
COORDENADA_INCOMPLETA <- herbario_coord_decimal %>%
  filter(., is.na(latitude) == TRUE | is.na(longitude) == TRUE)


### Latitude diferente de N ou S


# Latitude diferente de N ou S
LATITUDE_SEM_NS <- herbario_total %>%
  filter(., ns != "N" & ns != "S" & is.na(lat_grau) == FALSE)


### Longitude diferente de E ou W


# Longitude diferente de E ou W
LONGITUDE_SEM_EW <- herbario_total %>%
  filter(., ew != "E" & ew != "W" & is.na(long_grau) == FALSE)


### Latitude N


# Latitude N
LATITUDE_N <- herbario_total %>%
  filter(., ns == "N")


### Longitude E


# Longitude E
LONGITUDE_E <- herbario_total %>%
  filter(., ew == "E")


### Registros sem país


# Registro sem país
PAIS_VAZIO <- herbario_total %>%
  filter(., country == "" | is.na(country) == TRUE)


### Verifica nomes dos estados e municípios


# Verifica nomes dos Estados e Municípios
municipios <- read_ods("DTB_2025/RELATORIO_DTB_BRASIL_2025_MUNICIPIOS.ods", skip = 6) %>%
  select(., majorarea = Nome_UF, minorarea = Nome_Município)

NOME_ESTADO_ERRADO <- herbario_total %>%
  filter(., country == "Brasil" & !(majorarea %in% (unique(municipios$majorarea))))

NOME_MUNICIPIO_ERRADO <- herbario_total %>%
  filter(., country == "Brasil" & !(minorarea %in% (municipios$minorarea))) %>%
  select(codbarras, numtombo, majorarea, minorarea, everything())

# Combinações de estado e município erradas
COMBINACAO_EST_MUN_ERRADA <- herbario_total %>%
  filter(., country == "Brasil") %>%
  anti_join(., municipios, by = c("majorarea", "minorarea"))


### Coordenadas não correspondem ao município


# Carrega shapefile dos municípios
mun_shp <- st_read("BR_Municipios_2025/BR_Municipios_2025.shp")

# Registros com coordenadas completas
herbario_coord_completa <- herbario_coord_decimal %>%
  filter(., is.na(latitude) == FALSE & is.na(longitude) == FALSE)


pts <- st_as_sf(herbario_coord_completa,
                coords = c("longitude", "latitude"),
                crs = 4326,
                remove = FALSE)
mun_shp <- st_transform(mun_shp, crs = st_crs(pts))
joined <- st_join(pts, mun_shp, join = st_within) %>%
  mutate(shape = mun_shp[match(.$NM_MUN, mun_shp$NM_MUN),"geometry"]) %>%
  mutate(concorda_mun = ifelse(minorarea == NM_MUN, TRUE, FALSE)) %>%
  mutate(concorda_est = ifelse(majorarea == NM_UF, TRUE, FALSE))


COORD_E_ESTADO_INCOMPATIVEIS <- joined %>%
  filter(., concorda_est == FALSE) %>%
  select(codbarras, majorarea, NM_UF, minorarea, NM_MUN, latitude, longitude, everything())


# Registros cujo município não coincide com as coordenadas
coord_erradas <- joined %>%
  filter(concorda_mun == FALSE)

# Polígono do município informado para cada registro
municipios_informados <- mun_shp %>%
  select(
    majorarea = NM_UF,
    minorarea = NM_MUN,
    geom_municipio = geometry
  )

coord_erradas <- coord_erradas %>%
  left_join(
    st_drop_geometry(municipios_informados),
    by = c("majorarea", "minorarea")
  )

# Recupera as geometrias dos municípios
geom_municipios <- municipios_informados$geom_municipio[
  match(
    paste(coord_erradas$majorarea, coord_erradas$minorarea),
    paste(municipios_informados$majorarea,
          municipios_informados$minorarea)
  )
]

# Mesmo CRS métrico para tudo
coord_erradas <- st_transform(coord_erradas, 5880)

geom_municipios <- st_transform(
  st_sf(geometry = geom_municipios, crs = 4326),
  5880
)

# Distância ao limite do município informado
coord_erradas$distancia_m <- as.numeric(
  st_distance(
    st_geometry(coord_erradas),
    st_boundary(st_geometry(geom_municipios)),
    by_element = TRUE
  )
)

COORD_E_MUNICIP_INCOMPATIVEIS <- coord_erradas %>%
  mutate(
    distancia_km = round(distancia_m / 1000, 2)
  ) %>%
  select(
    codbarras,
    numtombo,
    majorarea,
    NM_UF,
    minorarea,
    NM_MUN,
    distancia_km,
    everything()
  ) %>%
  arrange(desc(distancia_km))


### Nome da unidade de conservação não encontrado na base de dados do MMA


# Carrega shapefile das unidades de conservação
uc_shp <- st_read("cnuc_2026_03_atualizado/cnuc_2026_03_atualizado.shp")

# Nomes das UCs
nomes_uc <- as.data.frame(uc_shp$nome_uc)

# Nomes no Jabot que não correspondem ao nomes de UCs registradas
NOME_UC_ERRADO_TODAS <- herbario_total %>%
  filter(., uc != "" & !(toupper(uc) %in% (uc_shp$nome_uc))) %>%
  select(., codbarras, uc, latitude, longitude, everything())


### Coordenadas não correspondem à unidade de conservação


pts_uc <- st_as_sf(herbario_coord_completa,
                   coords = c("longitude", "latitude"),
                   crs = 4326,
                   remove = FALSE)
uc_shp <- st_transform(uc_shp, crs = st_crs(pts_uc))
#uc_shp <- sf::st_make_valid(uc_shp)
joined_uc <- st_join(pts_uc, uc_shp[st_is_valid(uc_shp) == TRUE,], join = st_within)
joined_uc$concorda <- ifelse(toupper(joined_uc$uc) == joined_uc$nome_uc, TRUE, FALSE)


COORD_E_UC_INCOMPATIVEIS <- joined_uc %>%
  filter(., concorda == FALSE) %>%
  select(., codbarras, uc, nome_uc, minorarea, latitude, longitude, everything())


## Calcula a distância até a UC informada

# Quais registros estão dentro da UC informada?
uc_confere <- joined_uc %>%
  st_drop_geometry() %>%
  mutate(
    uc_jabot = toupper(uc),
    uc_shape = nome_uc
  ) %>%
  group_by(codbarras) %>%
  summarise(
    uc_encontrada = any(uc_jabot == uc_shape, na.rm = TRUE),
    .groups = "drop"
  )

# Mantém apenas registros cuja UC informada NÃO contém o ponto
uc_erradas <- joined_uc %>%
  distinct(codbarras, .keep_all = TRUE) %>%
  left_join(uc_confere, by = "codbarras") %>%
  filter(
    uc != "",
    uc_encontrada == FALSE
  )

# Geometria da UC informada
ucs_ref <- uc_shp %>%
  select(
    uc_shape = nome_uc,
    geom_uc = geometry
  )

# Recupera a geometria da UC indicada no registro
idx <- match(
  toupper(uc_erradas$uc),
  ucs_ref$uc_shape
)

geom_uc <- ucs_ref$geom_uc[idx]

# Converte para sistema métrico
uc_erradas_m <- st_transform(uc_erradas, 5880)

geom_uc_m <- st_transform(
  st_sf(geometry = geom_uc, crs = st_crs(uc_shp)),
  5880
)

# Distância até o limite da UC informada
uc_erradas_m$distancia_m <- as.numeric(
  st_distance(
    st_geometry(uc_erradas_m),
    st_boundary(st_geometry(geom_uc_m)),
    by_element = TRUE
  )
)

# Resultado final
DISTANCIA_UC <- uc_erradas_m %>%
  mutate(
    distancia_km = round(distancia_m / 1000, 2)
  ) %>%
  select(
    codbarras,
    numtombo,
    uc,
    distancia_km,
    everything()
  ) %>%
  arrange(desc(distancia_km))



### Erros espaciais em potencial


# Muda nomes de países para código de três letras
herbario_coord_completa_2 <- herbario_coord_completa
herbario_coord_completa_2$country <- countryname(herbario_coord_completa_2$country,
                                                 destination = "iso3c")

# Marca registros potencialmente problemáticos
flags <- clean_coordinates(x = herbario_coord_completa_2,
                           value = "spatialvalid",
                           lon = "longitude",
                           lat = "latitude",
                           countries = "country",
                           country_ref = ne_countries("large"),
                           species = NULL,
                           seas_ref = st_read("ne_10m_land/ne_10m_land.shp"),
                           seas_scale = 110,
                           tests = c("centroids",
                                     "equal",
                                     "gbif",
                                     "institutions",
                                     "zeros",
                                     "countries",
                                     "seas"))


# Plota registros provavelmente corretos (amarelo) e potencialmente errados (roxo)
plot(flags, lon = "longitude", lat = "latitude")



## Cria objetos com resultados dos testes
ERROS_POTENCIAIS <- filter(flags, .summary == FALSE) %>%
  select(1:7,62:69,8:61,70)

# Mostra quantos erros de cada tipo foram detectados
summary(ERROS_POTENCIAIS)


# Latitude e longitude iguais
LAT_LON_IGUAIS <- ERROS_POTENCIAIS %>%
  filter(., .equ == FALSE)

# Latitude ou longitude iguais a 0
LAT_LON_0 <- ERROS_POTENCIAIS %>%
  filter(., .zer == FALSE)

# Coordenada coincidente com o centroide de país
CENTROIDE_PAIS <- ERROS_POTENCIAIS %>%
  filter(., .cen == FALSE)

# Coordenada no mar
COORD_MAR <- ERROS_POTENCIAIS %>%
  filter(., .sea == FALSE)

# Coordenada em outro país
OUTRO_PAIS <- ERROS_POTENCIAIS %>%
  filter(., .con == FALSE)

# Coordenada coincidente com instituição de pesquisa
COORD_INST <- ERROS_POTENCIAIS %>%
  filter(., .inst == FALSE)


### Coordenadas fora do Brasil


brasil_ibge <- st_read("BR_Pais_2025/BR_Pais_2025.shp") %>%
  st_transform(4326)  # garante WGS84


coords_sf <- herbario_coord_decimal %>%
  filter(!is.na(latitude), !is.na(longitude)) %>%
  st_as_sf(coords = c("longitude", "latitude"),
           crs = 4326,
           remove = FALSE)

coords_sf$no_brasil <- st_within(coords_sf,
                                 brasil_ibge,
                                 sparse = FALSE)[,1]

COORD_FORA_BRASIL_SHAPE_IBGE <- coords_sf %>%
  filter(country == "Brasil",
         no_brasil == FALSE) %>%
  select(codbarras, numtombo, latitude, longitude, everything())




# Pontos fora do Brasil
pts_fora <- COORD_FORA_BRASIL_SHAPE_IBGE %>%
  st_as_sf(coords = c("longitude", "latitude"),
           crs = 4326,
           remove = FALSE)

ggplot() +
  geom_sf(data = brasil_ibge, fill = "gray95", color = "black") +
  geom_sf(data = pts_fora, color = "red", size = 1) +
  labs(title = "Registros com coordenadas fora do Brasil",
       subtitle = "Shape do IBGE") +
  theme_minimal()


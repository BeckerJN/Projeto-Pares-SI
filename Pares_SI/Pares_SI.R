
# Identificacao de pares infectante-infectado e estimativa de Intervalo serial (SI).


# Instalando e carregando pacotes.

if(!require(readxl)) install.packages("readxl"); library(readxl)
if(!require(tidyverse)) install.packages("tidyverse"); library(tidyverse)
if(!require(stringr)) install.packages("stringr");library(stringr)
if(!require(stringi)) install.packages("stringi");library(stringi)
if(!require(writexl))install.packages("writexl");library(writexl)


# Importando a planilha excel com registros de casos positivos de COVID-19.
  # A planilha deve obrigatoriamente conter os campos abaixo exatamente como nomeados:
  # NomeCompleto, NomeMae, DataInicioSintomas, Logradouro, Numero, Bairro, Municipio e Estado.

DadosCovid <- read_excel("Banco_Covid_Modelo.xlsx", sheet = "Positivos", skip = 0)


# Padronizando dados.

DadosCovid <- DadosCovid |> mutate(NomeCompleto = as.character(NomeCompleto))
DadosCovid <- DadosCovid |> mutate(NomeCompleto = str_replace_all(NomeCompleto, pattern = "[ /|!?|ºª°)(.,;:*-]", replacement = ""))
DadosCovid <- DadosCovid |> mutate(NomeCompleto = str_replace_all(NomeCompleto, pattern = "\\\\", replacement = ""))
DadosCovid <- DadosCovid |> mutate(NomeCompleto = str_replace_all(NomeCompleto, pattern = "[ ']", replacement = ""))
DadosCovid <- DadosCovid |> mutate(NomeCompleto = str_replace_all(NomeCompleto, pattern = "[ ´`]", replacement = ""))
DadosCovid <- DadosCovid |> mutate(NomeCompleto = str_replace_all(NomeCompleto, pattern = "\t", replacement = ""))
DadosCovid <- DadosCovid |> mutate(NomeCompleto = str_replace_all(NomeCompleto, pattern = "\n", replacement = ""))
DadosCovid <- DadosCovid |> mutate(NomeCompleto = str_replace_all(NomeCompleto, pattern = '"', replacement = ""))
DadosCovid <- DadosCovid |> mutate(NomeCompleto = str_replace_all(NomeCompleto, pattern = "[0123456789]", replacement = ""))
DadosCovid <- DadosCovid |> mutate(NomeCompleto = stri_trans_general(NomeCompleto, id = "Latin-ASCII"))
DadosCovid <- DadosCovid |> mutate(NomeCompleto = str_to_upper(NomeCompleto))
DadosCovid <- DadosCovid |> mutate(NomeCompleto = str_replace(NomeCompleto, pattern = " ", replacement = ""))

DadosCovid <- DadosCovid |> mutate(NomeMae = as.character(NomeMae))
DadosCovid <- DadosCovid |> mutate(NomeMae = str_replace_all(NomeMae, pattern = "[ /|!?|ºª°)(.,;:*-]", replacement = ""))
DadosCovid <- DadosCovid |> mutate(NomeMae = str_replace_all(NomeMae, pattern = "\\\\", replacement = ""))
DadosCovid <- DadosCovid |> mutate(NomeMae = str_replace_all(NomeMae, pattern = "[ ']", replacement = ""))
DadosCovid <- DadosCovid |> mutate(NomeMae = str_replace_all(NomeMae, pattern = "[ ´`]", replacement = ""))
DadosCovid <- DadosCovid |> mutate(NomeMae = str_replace_all(NomeMae, pattern = "\t", replacement = ""))
DadosCovid <- DadosCovid |> mutate(NomeMae = str_replace_all(NomeMae, pattern = "\n", replacement = ""))
DadosCovid <- DadosCovid |> mutate(NomeMae = str_replace_all(NomeMae, pattern = '"', replacement = ""))
DadosCovid <- DadosCovid |> mutate(NomeMae = str_replace_all(NomeMae, pattern = "[0123456789]", replacement = ""))
DadosCovid <- DadosCovid |> mutate(NomeMae = stri_trans_general(NomeMae, id = "Latin-ASCII"))
DadosCovid <- DadosCovid |> mutate(NomeMae = str_to_upper(NomeMae))
DadosCovid <- DadosCovid |> mutate(NomeMae = str_replace(NomeMae, pattern = " ", replacement = ""))

DadosCovid <- DadosCovid |> mutate(DataInicioSintomas = as.Date(DataInicioSintomas))
DadosCovid <- DadosCovid |> mutate(DataInicioSintomas = str_replace_all(DataInicioSintomas, pattern = " ", replacement = ""))
DadosCovid <- DadosCovid |> mutate(DataInicioSintomas = str_replace(DataInicioSintomas, pattern = " ", replacement = ""))

DadosCovid <- DadosCovid |> mutate(Logradouro = as.character(Logradouro))
DadosCovid <- DadosCovid |> mutate(Logradouro = str_replace_all(Logradouro, pattern = "[ /|!?|ºª°)(.,;:*-]", replacement = ""))
DadosCovid <- DadosCovid |> mutate(Logradouro = str_replace_all(Logradouro, pattern = "\\\\", replacement = ""))
DadosCovid <- DadosCovid |> mutate(Logradouro = str_replace_all(Logradouro, pattern = "[ ']", replacement = ""))
DadosCovid <- DadosCovid |> mutate(Logradouro = str_replace_all(Logradouro, pattern = "[ ´`]", replacement = ""))
DadosCovid <- DadosCovid |> mutate(Logradouro = str_replace_all(Logradouro, pattern = "\t", replacement = ""))
DadosCovid <- DadosCovid |> mutate(Logradouro = str_replace_all(Logradouro, pattern = "\n", replacement = ""))
DadosCovid <- DadosCovid |> mutate(Logradouro = str_replace_all(Logradouro, pattern = '"', replacement = ""))
DadosCovid <- DadosCovid |> mutate(Logradouro = stri_trans_general(Logradouro, id = "Latin-ASCII"))
DadosCovid <- DadosCovid |> mutate(Logradouro = str_to_upper(Logradouro))
DadosCovid <- DadosCovid |> mutate(Logradouro = str_replace(Logradouro, pattern = " ", replacement = ""))

DadosCovid <- DadosCovid |> mutate(Numero = as.character(Numero))
DadosCovid <- DadosCovid |> mutate(Numero = str_replace_all(Numero, pattern = "[ /|!?|ºª°)(.,;:*-]", replacement = ""))
DadosCovid <- DadosCovid |> mutate(Numero = str_replace_all(Numero, pattern = "\\\\", replacement = ""))
DadosCovid <- DadosCovid |> mutate(Numero = str_replace_all(Numero, pattern = "[ ']", replacement = ""))
DadosCovid <- DadosCovid |> mutate(Numero = str_replace_all(Numero, pattern = "[ ´`]", replacement = ""))
DadosCovid <- DadosCovid |> mutate(Numero = str_replace_all(Numero, pattern = "\t", replacement = ""))
DadosCovid <- DadosCovid |> mutate(Numero = str_replace_all(Numero, pattern = "\n", replacement = ""))
DadosCovid <- DadosCovid |> mutate(Numero = str_replace_all(Numero, pattern = '"', replacement = ""))
DadosCovid <- DadosCovid |> mutate(Numero = stri_trans_general(Numero, id = "Latin-ASCII"))
DadosCovid <- DadosCovid |> mutate(Numero = str_to_upper(Numero))
DadosCovid <- DadosCovid |> mutate(Numero = str_replace(Numero, pattern = " ", replacement = ""))

DadosCovid <- DadosCovid |> mutate(Bairro = as.character(Bairro))
DadosCovid <- DadosCovid |> mutate(Bairro = str_replace_all(Bairro, pattern = "[ /|!?|ºª°)(.,;:*-]", replacement = ""))
DadosCovid <- DadosCovid |> mutate(Bairro = str_replace_all(Bairro, pattern = "\\\\", replacement = ""))
DadosCovid <- DadosCovid |> mutate(Bairro = str_replace_all(Bairro, pattern = "[ ']", replacement = ""))
DadosCovid <- DadosCovid |> mutate(Bairro = str_replace_all(Bairro, pattern = "[ ´`]", replacement = ""))
DadosCovid <- DadosCovid |> mutate(Bairro = str_replace_all(Bairro, pattern = "\t", replacement = ""))
DadosCovid <- DadosCovid |> mutate(Bairro = str_replace_all(Bairro, pattern = "\n", replacement = ""))
DadosCovid <- DadosCovid |> mutate(Bairro = str_replace_all(Bairro, pattern = '"', replacement = ""))
DadosCovid <- DadosCovid |> mutate(Bairro = stri_trans_general(Bairro, id = "Latin-ASCII"))
DadosCovid <- DadosCovid |> mutate(Bairro = str_to_upper(Bairro))
DadosCovid <- DadosCovid |> mutate(Bairro = str_replace(Bairro, pattern = " ", replacement = ""))

DadosCovid <- DadosCovid |> mutate(Municipio = as.character(Municipio))
DadosCovid <- DadosCovid |> mutate(Municipio = str_replace_all(Municipio, pattern = "[ /|!?|ºª°)(.,;:*-]", replacement = ""))
DadosCovid <- DadosCovid |> mutate(Municipio = str_replace_all(Municipio, pattern = "\\\\", replacement = ""))
DadosCovid <- DadosCovid |> mutate(Municipio = str_replace_all(Municipio, pattern = "[ ']", replacement = ""))
DadosCovid <- DadosCovid |> mutate(Municipio = str_replace_all(Municipio, pattern = "[ ´`]", replacement = ""))
DadosCovid <- DadosCovid |> mutate(Municipio = str_replace_all(Municipio, pattern = "\t", replacement = ""))
DadosCovid <- DadosCovid |> mutate(Municipio = str_replace_all(Municipio, pattern = "\n", replacement = ""))
DadosCovid <- DadosCovid |> mutate(Municipio = str_replace_all(Municipio, pattern = '"', replacement = ""))
DadosCovid <- DadosCovid |> mutate(Municipio = stri_trans_general(Municipio, id = "Latin-ASCII"))
DadosCovid <- DadosCovid |> mutate(Municipio = str_to_upper(Municipio))
DadosCovid <- DadosCovid |> mutate(Municipio = str_replace(Municipio, pattern = " ", replacement = ""))

DadosCovid <- DadosCovid |> mutate(Estado = as.character(Estado))
DadosCovid <- DadosCovid |> mutate(Estado = str_replace_all(Estado, pattern = "[ /|!?|ºª°)(.,;:*-]", replacement = ""))
DadosCovid <- DadosCovid |> mutate(Estado = str_replace_all(Estado, pattern = "\\\\", replacement = ""))
DadosCovid <- DadosCovid |> mutate(Estado = str_replace_all(Estado, pattern = "[ ']", replacement = ""))
DadosCovid <- DadosCovid |> mutate(Estado = str_replace_all(Estado, pattern = "[ ´`]", replacement = ""))
DadosCovid <- DadosCovid |> mutate(Estado = str_replace_all(Estado, pattern = "\t", replacement = ""))
DadosCovid <- DadosCovid |> mutate(Estado = str_replace_all(Estado, pattern = "\n", replacement = ""))
DadosCovid <- DadosCovid |> mutate(Estado = str_replace_all(Estado, pattern = '"', replacement = ""))
DadosCovid <- DadosCovid |> mutate(Estado = stri_trans_general(Estado, id = "Latin-ASCII"))
DadosCovid <- DadosCovid |> mutate(Estado = str_to_upper(Estado))
DadosCovid <- DadosCovid |> mutate(Estado = str_replace(Estado, pattern = " ", replacement = ""))


# Excluindo registros com campos em branco.
# NomeCompleto, DataInicioSintomas, Logradouro, Numero, Bairro, Municipio e Estado.

DadosCovid[DadosCovid == ""] <- NA

DadosCovid <- DadosCovid |> filter(!(is.na(NomeCompleto)))
DadosCovid <- DadosCovid |> filter(!(is.na(DataInicioSintomas)))
DadosCovid <- DadosCovid |> filter(!(is.na(Logradouro)))
DadosCovid <- DadosCovid |> filter(!(is.na(Numero)))
DadosCovid <- DadosCovid |> filter(!(is.na(Bairro)))
DadosCovid <- DadosCovid |> filter(!(is.na(Municipio)))
DadosCovid <- DadosCovid |> filter(!(is.na(Estado)))


# Criando campo ChavePaciente.

DadosCovid <- DadosCovid |> mutate(ChavePaciente = str_c(NomeCompleto, Logradouro, Numero, Bairro, Municipio, Estado))


# Ordenando ChavePaciente A-Z.

DadosCovid <- DadosCovid |> arrange(DataInicioSintomas)
DadosCovid <- DadosCovid |> arrange(ChavePaciente)


# Separando banco DadosCovid em sem registros duplicados e em registros duplicados.

DadosSemDuplicados <- DadosCovid[!duplicated(DadosCovid$ChavePaciente), ]
DadosDuplicados <- DadosCovid[duplicated(DadosCovid$ChavePaciente), ]


# Contando registros duplicados.

Contador <- nrow(DadosDuplicados)


# Definindo limite de tempo para reinfeccao.

LimiteTempoReinfeccao <- 90


# Selecionando registros não duplicados e com tempo de reinfecção igual ou acima do limite de tempo definido.

DadosSelecionados <- DadosCovid[!duplicated(DadosCovid$ChavePaciente), ]

while (Contador > 0) {

DadosUniao <- inner_join(DadosSemDuplicados,DadosDuplicados,by="ChavePaciente")
DadosUniao <- DadosUniao |> mutate(TempoReinfeccao = abs(difftime(DataInicioSintomas.y, DataInicioSintomas.x, units = "days")))
DadosUniao <- DadosUniao |> filter(TempoReinfeccao >= LimiteTempoReinfeccao)
DadosUniao <- DadosUniao |> select(-TempoReinfeccao, -NomeCompleto.x, -NomeMae.x, -DataInicioSintomas.x, -Logradouro.x, -Numero.x, -Bairro.x, -Municipio.x, -Estado.x)
DadosUniao <- DadosUniao |> rename(NomeCompleto = NomeCompleto.y, NomeMae = NomeMae.y, DataInicioSintomas = DataInicioSintomas.y, Logradouro = Logradouro.y, Numero = Numero.y, Bairro = Bairro.y, Municipio = Municipio.y, Estado = Estado.y)

DadosSemDuplicados <- DadosUniao[!duplicated(DadosUniao$ChavePaciente), ]
DadosDuplicados <- DadosUniao[duplicated(DadosUniao$ChavePaciente), ]

DadosSelecionados <- rbind(DadosSelecionados, DadosSemDuplicados)

Contador <- nrow(DadosDuplicados)

}


# Criando banco DadosPaciente.

DadosPaciente <- DadosSelecionados |> rename(Chave = ChavePaciente)


# Criando banco DadosMae.

DadosMae <- DadosSelecionados |> select(-ChavePaciente)
DadosMae <- DadosMae |> filter(!(is.na(NomeMae)))
DadosMae <- DadosMae |> mutate(Chave = str_c(NomeMae, Logradouro, Numero, Bairro, Municipio, Estado))


# Realizando uniao entre bancos DadosPaciente e DadosMae.
  # Identificando provaveis pares infectante-infectado.

DadosParesSI <- inner_join(DadosPaciente,DadosMae,by="Chave")
DadosParesSI <- DadosParesSI |> arrange(DataInicioSintomas.x)
DadosParesSI <- DadosParesSI |> arrange(Chave)


# Definindo limites de tempo para o Intervalo Serial (SI).

LimiteMinTempoSI <- 0
LimiteMaxTempoSI <- 24


# Selecionando pares com SI dentro do limite de tempo definido.

DadosParesSI <- DadosParesSI |> mutate(TempoSI = abs(difftime(DataInicioSintomas.x, DataInicioSintomas.y, units = "days")))
DadosParesSI <- DadosParesSI |> filter(TempoSI <= LimiteMaxTempoSI)
DadosParesSI <- DadosParesSI |> filter(TempoSI >= LimiteMinTempoSI)


# Calculando o SI.

SI_mean <- mean(DadosParesSI$TempoSI)
print(SI_mean)

SI_sd <- sd(DadosParesSI$TempoSI)
print(SI_sd)


# Exportando arquivo DadosParesSI

write_xlsx(x = DadosParesSI, path = "DadosParesSI.xlsx")


# FIM #




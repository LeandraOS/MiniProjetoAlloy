-- autora: Leandra de Oliveira Silva
module sistemaDeCaronas

sig Carona{
	horarioCarona: one HorariosCarona,
	passageiros: set Passageiros,
	regiaoCarona: one Regioes,
	motorista: one Motorista
}

abstract sig HorariosCarona{

}
one sig HrSeteMeia, HrNoveMeia, HrUmaMeia, HrTresMeia extends HorariosCarona {
}

one sig DezHrs, DozeHrs, QuatroHrs, SeisHrs extends HorariosCarona {
}

abstract sig Passageiros {
    regiaoCarona: one Regioes,
    horarioCarona: one HorariosCarona
}

sig Servidor extends Passageiros{
}

sig Aluno extends Passageiros {
}

sig Professor extends Passageiros {
}

abstract sig Regioes {
}

one sig ALTOBRANCO, PRATA, CENTRO, BODOCONGO, SERROTAO, SOLANEA, ESPERANCA extends Regioes{
}

sig Motorista{
   regiaoCarona: one Regioes, 
   horarioCarona: one HorariosCarona
}

fact{
-- Na carona deve existir pelo menos uma pessoa, ou seja, o motorista.
    #Carona >= 1

-- Na carona  deve existir no maximo tres passageiros.
    #Carona.passageiros <= 3

-- A cada carona ha pelo menos um passageiro.  
    all passageiro: Passageiros | some passageiro.regiaoCarona

-- A cada carona deve haver um motorista.
    all motorista: Motorista | one motorista.regiaoCarona

-- A regiao da carona eh igual a regiao do motorista e do(s) passageiro(s).
    all carona: Carona | carona.regiaoCarona = carona.motorista.regiaoCarona and carona.regiaoCarona = carona.passageiros.regiaoCarona

    all motorista: Motorista, passageiro: Passageiros, carona: Carona |	
-- O horario de disponibilidade de carona do motorista eh igual ao horario de necessidade de carona do passageiro e 
    motorista.horarioCarona = passageiro.horarioCarona and 

-- O horario estabelicido para a carona eh igual ao horario que o passageiro tem a necessidade de carona. 
    carona.horarioCarona = passageiro.horarioCarona

-- Se ha duas caronas com o mesmo passageiro as duas caronas sao em horarios diferentes.
    all caronaUm: Carona, caronaDois: Carona, passageiro: Passageiros |
    ((passageiro in caronaUm.passageiros and passageiro in caronaDois.passageiros and caronaUm != caronaDois) implies
    caronaUm.horarioCarona != caronaDois.horarioCarona)

-- Todas as caronas que possuem o mesmo motorista sao em horarios diferentes.
    all caronaUm: Carona, caronaDois: Carona | (caronaUm.motorista = caronaDois.motorista and caronaUm != caronaDois) implies ( caronaUm.horarioCarona != caronaDois.horarioCarona)

}

pred show [] {}
run show for 10

# Solução URP
- Solução desenvolvida por Gabriel Kishida para o desafio de desenvolver um shader foto-realista de Raios X:

![image](https://github.com/user-attachments/assets/48c8b0e2-3a90-42be-a8ca-ed4d93007dbc)

Esta solução faz a passagem da informação da profundidade entre os dois shaders por meio de uma única textura.

Prós:
- Mais leve;
- Ocupa menos memória (apenas uma textura);
- É possível de ser visualizada sem iniciar a simulação.

Contras:
- Não funciona bem quando se colocam dois objetos, um atrás do outro.

# Agenda: Projeto criado para a cadeira de Engenharia de Software!

## Ferramentas utilizadas: Flutter Framework (2.2.3), Figma (Wireframes) e Draw.io
Flutter: https://https://flutter.dev <br>
Figma: https://www.figma.com <br>
Draw.io: https://app.diagrams.net <br>

## Equipe:
- Ana Karolina Costa da Silva
- João Victor Santos Sampaio 
- Joel Araújo da Silva
- José Arlindo Alcântara

## Resumo:
#### Nosso aplicativo se sustena na criação de uma agenda pessoal aonde um usuário pode salvar seus contatos, salvá-los em grupos, editar as informações de ambos contatos e ou grupos e ter acesso à essas informações em qualquer dispositivo, tendo em vista que essas informações são salvas em nuvem.

## Como baixar a apk de teste?
> Nos arquivos do projeto acesse a pasta 'Build/App/Outputs/flutter-apk/ e baixe o arquivo app.apk
> Também é possível baixar o aplicativo através da pasta 'Build/App/Outputs/apk/debug/ baixando o arquivo app-debug.apk

## 1) Elaborar o documento de especificação de requisitos com base no modelo disponibilizado pelo professor. 
> ## Contato
- [X] Criar contato
- [X] Deletar contato
- [X] Editar contato
- [X] Pesquisar por contatos

> ## Grupo
- [X] Criar grupo
- [X] Deletar grupo
- [X] Editar grupo
- [X] Pesquisar por grupos

> ## Login
- [X] Entrar na conta
- [X] Recuperar senha da conta

> ## Cadastro
- [X] Criar conta

## 2) Wireframe
![image](https://user-images.githubusercontent.com/42116724/125640690-e8bffe1b-175b-4aa0-b17d-407ed580d275.png)
![image](https://user-images.githubusercontent.com/42116724/125640721-74e5a3aa-28a3-4c92-95b4-d501c63527db.png)
![image](https://user-images.githubusercontent.com/42116724/125640748-848f449e-7982-4d7b-823d-7c942eb2883c.png)
![image](https://user-images.githubusercontent.com/42116724/125640787-e2ec5ac2-cb14-4b4b-8af7-846bca22ed27.png)

## 3) UML
a) Casos de uso
![Diagrama de casos de uso](https://user-images.githubusercontent.com/42116724/125643454-6cdff0c6-37a0-4901-bec8-a2250de4a0ba.png)

b) Sequência
![Diagrama de sequência 01](https://user-images.githubusercontent.com/42116724/125643459-8ffd29d0-6053-463f-bb91-d18c5ac9e8f3.png)
![Diagrama de sequência 02](https://user-images.githubusercontent.com/42116724/125643460-58141172-21a8-47bd-81e4-d3e2932a8cff.png)

c) Atividade
![Diagrama de atividades 01](https://user-images.githubusercontent.com/42116724/125643448-2f9d2b5c-eb8a-4a6c-a67d-0b7f0c324244.png)
![Diagrama de atividades 02](https://user-images.githubusercontent.com/42116724/125643452-43f51888-059d-4cc8-86b0-b15cc1b51cdb.png)

e) Estado
![Diagrama de estado](https://user-images.githubusercontent.com/42116724/125643456-97b9d859-3dbf-421e-8c09-e1196d062642.png)

f) Implantação <br>
![image](https://user-images.githubusercontent.com/42116724/125655992-209cf8c1-13a8-49d8-b4c4-1fae33a09047.png)

g) Componentes <br>
![eng_soft_agenda (2)](https://user-images.githubusercontent.com/42116724/125658412-b1c61c2c-0c23-4b4a-bb11-8a1c72f92953.png)

## 4) Implementação Parte I

Nosso aplicativo conta com a implementação tanto de Observers quanto de uma Factory, de modo a cumprir os requisitos de Design pattern solicitados.
O Flutter por si só já possui uma gama de componentes que nos ajuda a tratar facilmente dessa necessidade de observers, os **StreamBuilders**, que em conjunto com **StatefulBuilders** nos permitem não apenas manter um fluxo contínuo em tempo real com nosso banco de dados (Firebase), "escutar" ou "observar" a qualquer mudança feita nos documentos salvos no banco de dados como também nos permitem atualizar apenas os componentes visuais que realmente precisam de alteração, "recarregando" apenas a parte da tela necessária.
Para a utilização das Factories nos a utilizamos na criação da instância das *ata-Classes* de Grupo ou Objeto, dessa forma é possível rapidamente retornar um Singleton e trabalhar em cima dessas instâncias.

## 5) Implementação Parte 2

O projeto foi criado utilizando o framework de desenvolvimento híbrido mencionado no início dessa documentação, o Flutter. A partir desse framework utilizamos a grande disposição de bibliotecas do framework para gerenciamento de estado e utlizar comunicação com a plataforma Firebase.
No aplicativo contamos com a ajuda dos ListenerProviders, que são extensões que nos possibilitam criar uma classe de dados e utlizar essas classes como instâncias globais, de forma que as mesmas se tornam nossos controllers, o que solidifica a aplicação da arquitetura MVC no projeto.
Além disso, por serem instâncias imutáveis (tendo apenas suas propriedades como passivas de alteração), os ListenerProviders nos permitiram receber e utilizar as instâncias das *data-classes* **Contato** e **Grupo** sem problemas com *null-safety*.






# Prova 3 de Desenvolvimento de Aplicações Móveis 2 - Anuncios de Carros

Crie um aplicativo em Flutter, utilizandos os web-services disponibilizados na URL
**http://argo.td.utfpr.edu.br/carros/ws/<recurso>** permitam que um usuário realize as
seguintes operações:
* a) Manter o cadastro (inclusão, alteração e remoção) de **marcas, modelos, cidades e anuncios** de
venda de veículos.
* b) Buscar veículos anunciados, filtrando por modelo, ano e valor.

Ao enviar um novo registro (de qualquer tipo) não é necessário informar o id do novo objeto, pois o
servidor irá gerar um id no momento da inserção no banco de dados. No PUT, deverá ser enviado o
objeto com o id original, e o mesmo deve ser igual ao da URL.

Para as classes com mapeamento muitos-para-um, deve ser enviado o ID do objeto relacionado no
campo id<Classe>. Exemplo: para cadastrar um modelo da marca Audi (id = 1), o JSON enviado no
POST deve ser (tipos já existentes: SEDAN, HATCH, SUV e CAMIONETE)

{ "nome" : "A4 Turbo", "idMarca" : 1, "tipo" : "SEDAN" }

Para a busca dos modelos (GET no recurso raiz), há um filtro de marca:
* **http://.../carros/ws/modelos?marca=13**

Para a busca de cidades, há um filtro de nome:
* **http://.../carros/ws/cidades?nome=Tol**

Para a busca dos anúncios (GET no recurso raiz), há filtro de modelo, ano inicial e final, além do
valor mínimo e valor máximo.
* **http://.../carros/ws/anuncios?
modelo=13&ano_inicial=2020&ano_final=2024&min=20000&max=60000**

Todos os parâmetros são opcionais.

## Classes do lado do servidor:

public class Marca {
    private Long id;
    private String nome;
}

public class Modelo {
    private Long id;
    private String nome;
    private Long idMarca;
    private Marca marca;
}

public class Cidade {
    private Long id;
    private String nome;
    private String ddd;
}

public class Anuncio {
    private Long id;
    private Modelo modelo;
    private Cidade cidade;
    private String descricao;
    private Double valor;
    private Integer ano;
    private Integer km;
    private Long idCidade;
    private Long idModelo;
}

Todos os recursos obedecem ao padrão:

* A URL raiz suporta GET para listar e POST insere um novo objeto no BD. Exemplo para
listar os modelos de uma marca:

**http://argo.td.utfpr.edu.br/carros/ws/modelos?marca=19**
* A URL raiz, acrescentada de um id suporta GET para consultar, PUT para alterar (não é
possível alterar o id), e DELETE remove um objeto no BD. Ex: para alterar uma cidade
com id = 4, enviar PUT para a URL, contendo o JSON com os novos dados da cidade. O id
da cidade enviada deve ser 4.

**http://argo.td.utfpr.edu.br/carros/ws/cidades/43**
* Para simplificar o cadastro de objetos que tem relacionamento com outras objetos (Modelo
e Anuncio), foram inseridos atributos para especificar o id do objeto relacionado (idMarca,
idModelo e idCidade, respectivamente). Basta informá-los nos métodos POST e PUT para
especificar o relacionamento.

Utilizar o padrão MVVM para a implementação do projeto.
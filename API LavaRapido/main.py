from datetime import date
from fastapi import FastAPI, HTTPException, Depends, status
from sqlalchemy.orm import Session
from data.database import get_db, engine, Base
from fastapi.middleware.cors import CORSMiddleware

from model.Fornecedor import FornecedorRequest, FornecedorResponse, Fornecedor
from repository.fornecedor_repository import FornecedorRepository
from model.Produto import ProdutoResponse, ProdutoRequest, Produto
from repository.produto_repository import ProdutoRepository


Base.metadata.create_all(bind=engine)
app = FastAPI(
    title="API lava-rápido",
    description=
        """API de lava-rápido que foi desenvolvida utilizando FastAPI. Ela fornece uma interface 
        eficiente e segura para operações GET, POST, PUT e DELETE.""",
    version="1.0.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/")
def index():
    return {"informacao" : "API lava-rápido"}

# Fornecedor
# Recurso 1 - GET by ID e POST
@app.get('/api/fornecedor/{id}', response_model=FornecedorResponse, tags=["Fornecedor GET by ID e POST"])
def recuperar_fornecedor_por_id(id: int, db: Session = Depends(get_db)):
    fornecedor = FornecedorRepository.get_by_id(db, id)
    if not fornecedor:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Fornecedor não encontrado")
    return fornecedor


@app.post('/api/fornecedor', response_model=FornecedorResponse, status_code=status.HTTP_201_CREATED, tags=["Fornecedor GET by ID e POST"])
def criar_fornecedor(request: FornecedorRequest, db:Session = Depends(get_db)):
    fornecedorExiste = FornecedorRepository.get_by_cnpj(db, request.cnpj)
    if fornecedorExiste:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Fornecedor já está cadastrado")
    
    return FornecedorRepository.save(db, Fornecedor(**request.model_dump()))

# Recurso 2 - GET all
@app.get('/api/fornecedores', response_model=list[FornecedorResponse], tags=["Fornecedor GET all"])
def recuperar_todos_fornecedores(db: Session = Depends(get_db)):
    fornecedores = FornecedorRepository.get_all(db)
    if not fornecedores:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Não há fornecedores cadastrados")
    return fornecedores

# Recurso 3 - PUT e DELETE
@app.put('/api/fornecedor/{id}', response_model=FornecedorResponse, tags=["Fornecedor PUT e DELETE"])
def atualizar_fornecedor(id: int, request: FornecedorRequest, db:Session = Depends(get_db)):
    fornecedor = db.query(Fornecedor).filter(Fornecedor.id == id).first()
    if not fornecedor:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Fornecedor não encontrado")
    
    fornecedorExiste = db.query(Fornecedor).filter(Fornecedor.cnpj == request.cnpj).first()
    if fornecedorExiste.id != id:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="CNPJ utilizado por outro fornecedor")
    
    return FornecedorRepository.save(db, Fornecedor(id=id, **request.model_dump()))


@app.delete("/api/fornecedor/{id}", status_code=status.HTTP_204_NO_CONTENT, tags=["Fornecedor PUT e DELETE"])
def deletar_fornecedor(id: int, db: Session = Depends(get_db)):
    statusDeletarFornecedor = FornecedorRepository.delete(db, id)
    if not statusDeletarFornecedor:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Fornecedor não encontrado")
    
    else:
        raise HTTPException(status_code=status.HTTP_200_OK, detail="Fornecedor deletado com sucesso")
    

# Produto
# Recurso 1 - GET by ID e POST
@app.get('/api/produto/{id}', response_model=ProdutoResponse, tags=["Produto GET by ID e POST"])
def recuperar_produto_por_id(id: int, db: Session = Depends(get_db)):
    produto = ProdutoRepository.get_by_id(db, id)
    if not produto:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Produto não encontrado")
    return produto


@app.post('/api/produto', response_model=ProdutoResponse, status_code=status.HTTP_201_CREATED, tags=["Produto GET by ID e POST"])
def adicionar_produto(request: ProdutoRequest, db:Session = Depends(get_db)):
    produtoModelo = ProdutoRepository.get_by_model(db, request.modelo)
    produtoMarca = ProdutoRepository.get_by_brand(db, request.marca)

    if produtoModelo and produtoMarca:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Produto já está cadastrado")
    
    return ProdutoRepository.save(db, Produto(**request.model_dump()))

# Recurso 2 - GET all
@app.get('/api/produtos', response_model=list[ProdutoResponse], tags=["Produto GET all"])
def recuperar_todos_produtos(db: Session = Depends(get_db)):
    produtos = ProdutoRepository.get_all(db)
    if not produtos:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Não há produtos cadastrados")
    return produtos

# Recurso 3 - PUT e DELETE
@app.put('/api/produto/{id}', response_model=ProdutoResponse, tags=["Produto PUT e DELETE"])
def atualizar_produto(id: int, request: ProdutoRequest, db:Session = Depends(get_db)):
    produtoExiste = ProdutoRepository.get_by_id(db, id)
    if not produtoExiste:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Produto não encontrado")

    return ProdutoRepository.save(db, Produto(id=id, **request.model_dump()))


@app.delete("/api/produto/{id}", status_code=status.HTTP_204_NO_CONTENT, tags=["Produto PUT e DELETE"])
def deletar_produto(id: int, db: Session = Depends(get_db)):
    statusDeletarProduto = ProdutoRepository.delete(db, id)
    if not statusDeletarProduto:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Produto não encontrado")
    
    else:
        raise HTTPException(status_code=status.HTTP_200_OK, detail="Produto deletado com sucesso")
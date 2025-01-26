from __future__ import annotations
from sqlalchemy.orm import Session
from model.Produto import Produto

class ProdutoRepository:
    # Retorna produto por id
    @staticmethod
    def get_by_id(db: Session, id: int) -> Produto | None:
        return db.query(Produto).filter(Produto.id == id).first()
    
     # Cria ou altera produto
    @staticmethod
    def save(db: Session, produto: Produto) -> Produto:
        if (produto.id):
            db.merge(produto)
        else:
            db.add(produto)
        db.commit()
        return produto
    
    # Retorna todos os produtos
    @staticmethod
    def get_all(db: Session) -> list[Produto]:
        return db.query(Produto).all()
    
    # Remove produto
    @staticmethod
    def delete(db: Session, id: int) -> bool:
        produto = db.query(Produto).filter(Produto.id == id).first()
        if produto:
            db.delete(produto)
            db.commit()
            return True
        return False
    
    # Retorna modelo 
    @staticmethod
    def get_by_model(db: Session, model: str) -> Produto | None:
        return db.query(Produto).filter(Produto.modelo == model).first()
    
    # Retorna marca
    def get_by_brand(db: Session, marca: str) -> Produto | None:
        return db.query(Produto).filter(Produto.marca == marca).first()
from __future__ import annotations
from sqlalchemy.orm import Session
from model.Fornecedor import Fornecedor

class FornecedorRepository:
    # Retorna fornecedor por id
    @staticmethod
    def get_by_id(db: Session, id: int) -> Fornecedor | None:
        return db.query(Fornecedor).filter(Fornecedor.id == id).first()
    
     # Cria ou altera fornecedor
    @staticmethod
    def save(db: Session, fornecedor: Fornecedor) -> Fornecedor:
        if (fornecedor.id):
            db.merge(fornecedor)
        else:
            db.add(fornecedor)
        db.commit()
        return fornecedor
    
    # Retorna CNPJ caso cadastrado
    @staticmethod
    def get_by_cnpj(db: Session, cnpj: str) -> Fornecedor | None:
        return db.query(Fornecedor).filter(Fornecedor.cnpj == cnpj).first()
    
     # Retorna todos os fornecedores
    @staticmethod
    def get_all(db: Session) -> list[Fornecedor]:
        return db.query(Fornecedor).all()
    
    # Remove funcionário
    @staticmethod
    def delete(db: Session, id: int) -> bool:
        fornecedor = db.query(Fornecedor).filter(Fornecedor.id == id).first()
        if fornecedor:
            db.delete(fornecedor)
            db.commit()
            return True
        return False
from pydantic import BaseModel
from data.database import Base
from sqlalchemy import Column, VARCHAR, INTEGER

class Fornecedor(Base):
    __tablename__ = "tb_fornecedor"

    id:  int = Column(INTEGER, primary_key=True, autoincrement=True)
    nome: str = Column(VARCHAR(100), nullable=False)
    cnpj: str = Column(VARCHAR(100), nullable=False)
    telefone: str = Column(VARCHAR(100), nullable=False)
    email: str = Column(VARCHAR(100), nullable=False)
    cep: str = Column(VARCHAR(100), nullable=False)
    logradouro: str = Column(VARCHAR(255), nullable=False)
    bairro: str = Column(VARCHAR(100), nullable=False)
    numero: int = Column(INTEGER,  nullable=False)
    complemento: str = Column(VARCHAR(100), nullable=True)
    cidade: str = Column(VARCHAR(100), nullable=False)
    estado: str = Column(VARCHAR(100), nullable=False)


class FornecedorBase(BaseModel):
    nome: str
    cnpj: str
    telefone: str
    email: str
    cep: str
    logradouro: str
    bairro: str
    numero: int
    complemento: str
    cidade: str
    estado: str


class FornecedorRequest(FornecedorBase):
    ...


class FornecedorResponse(FornecedorBase):
    id: int

    class Config:
        from_attributes = True
        populate_by_name = True
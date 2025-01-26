from pydantic import BaseModel
from data.database import Base
from sqlalchemy import Column, ForeignKey, VARCHAR, CheckConstraint, INTEGER, NUMERIC, TEXT

class Produto(Base):
    __tablename__ = "tb_produto"

    id: int = Column(INTEGER, primary_key=True, autoincrement=True)
    modelo: str = Column(VARCHAR(100), nullable=False)
    marca: str = Column(VARCHAR(100), nullable=False)
    descricao: str = Column(TEXT, nullable=False)
    quantidade: int = Column(INTEGER, CheckConstraint('quantidade > 0'), nullable=False)
    valorUnitario: float = Column(NUMERIC(precision=10, scale=2), CheckConstraint('valorUnitario >= 0'), nullable=False)
    idFornecedor: int = Column(INTEGER, ForeignKey("tb_fornecedor.id"), nullable=False)

class ProdutoBase(BaseModel):
    modelo: str
    marca: str
    descricao: str
    quantidade: int
    valorUnitario: float
    idFornecedor: int

class ProdutoRequest(ProdutoBase):
    ...


class ProdutoResponse(ProdutoBase):
    id: int

    class Config:
        from_attributes = True
        populate_by_name = True
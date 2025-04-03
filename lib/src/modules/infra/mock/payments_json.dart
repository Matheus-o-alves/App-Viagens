final Map<String, dynamic> mockPaymentsJson = {
  "travelExpenses": [
    {
      "id": 1,
      "expenseDate": "2024-07-03T00:00:00",
      "description": "Passagem aérea São Paulo - Rio de Janeiro",
      "category": "Transporte",
      "amount": 850,
      "reimbursable": true,
      "isReimbursed": true,
      "status": "approved",
      "paymentMethod": "Cartão Corporativo"
    },
    {
      "id": 2,
      "expenseDate": "2024-07-18T00:00:00",
      "description": "Hospedagem - Hotel Windsor Oceânico",
      "category": "Hospedagem",
      "amount": 1240.5,
      "reimbursable": true,
      "isReimbursed": true,
      "status": "approved",
      "paymentMethod": "Cartão Corporativo"
    },
    {
      "id": 15,
      "expenseDate": "2025-01-16T00:00:00",
      "description": "Almoço de negócios - Restaurante Fasano",
      "category": "Alimentação",
      "amount": 385.9,
      "reimbursable": false,
      "isReimbursed": false,
      "status": "pending_approval",
      "paymentMethod": "Dinheiro"
    },
    {
      "id": 18,
      "expenseDate": "2025-02-27T00:00:00",
      "description": "Táxi Aeroporto - Hotel",
      "category": "Transporte",
      "amount": 76.5,
      "reimbursable": true,
      "isReimbursed": false,
      "status": "scheduled",
      "paymentMethod": "Aplicativo"
    },
    {
      "id": 23,
      "expenseDate": "2025-03-05T00:00:00",
      "description": "Aluguel de carro - Localiza",
      "category": "Transporte",
      "amount": 420,
      "reimbursable": true,
      "isReimbursed": false,
      "status": "pending_approval",
      "paymentMethod": "Cartão Corporativo"
    },
    {
      "id": 27,
      "expenseDate": "2025-03-10T00:00:00",
      "description": "Jantar com cliente - Restaurante Mee",
      "category": "Alimentação",
      "amount": 650.75,
      "reimbursable": true,
      "isReimbursed": false,
      "status": "scheduled",
      "paymentMethod": "Cartão Corporativo"
    }
  ],
  "cards": [  
    {
      "id": 1,
      "nome": "Cartão Corporativo Principal",
      "numero": "**** **** **** 1234",
      "titular": "Onfly Me Contrata", 
      "validade": "12/2026",
      "bandeira": "Visa",
      "limiteDisponivel": 5000.0
    }
  ]
};
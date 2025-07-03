from flask import Flask, render_template, request, jsonify, session

app = Flask(__name__)
app.secret_key = 'super_secret_key' # Chave secreta para gerenciar sessões

# Dados dos itens (poderiam vir de um banco de dados, por exemplo)
items = {
    "item1": {"name": "Camisa", "price": 49.90},
    "item2": {"name": "Calça Jeans", "price": 99.90},
    "item3": {"name": "Tênis", "price": 149.90},
    "item4": {"name": "Boné", "price": 29.90},
    "item5": {"name": "Meia", "price": 9.90}
}

@app.route('/')
def index():
    # Inicializa o carrinho na sessão se ainda não existir
    if 'cart' not in session:
        session['cart'] = []
    return render_template('index.html', items=items)

@app.route('/add_to_cart', methods=['POST'])
def add_to_cart():
    item_id = request.form.get('item_id')
    if item_id in items:
        item = items[item_id]
        session['cart'].append(item)
        session.modified = True # Notifica a sessão que houve modificação
    return jsonify(success=True, cart=session.get('cart', []))

@app.route('/clear_cart', methods=['POST'])
def clear_cart():
    session['cart'] = []
    session.modified = True
    return jsonify(success=True, cart=[])

@app.route('/get_cart', methods=['GET'])
def get_cart():
    return jsonify(cart=session.get('cart', []))

if __name__ == '__main__':
    app.run(debug=True)
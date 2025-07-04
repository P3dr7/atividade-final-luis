***Settings***
Library    SeleniumLibrary    timeout=5s
# Certifique-se de que o teardown está presente em todos os casos de teste,
# ou adicione um Teardown de Suíte se preferir.
# Suite Teardown    Close All Browsers # Uma alternativa ao Teardown por Test Case

***Variables***
${URL}           http://127.0.0.1:5000/
${BROWSER}       Chrome

***Test Cases***
Cenário: Adicionar Item ao Carrinho e Verificar Total
    [Tags]    FuncionalidadeCarrinho
    # Adicionar as opções para o Chrome aqui
    Open Browser    ${URL}    ${BROWSER}    options=add_argument("--headless");add_argument("--no-sandbox");add_argument("--disable-dev-shm-usage");add_argument("--disable-gpu")
    Maximize Browser Window
    Wait Until Page Contains Element    css:body
    # Pequena pausa para garantir que tudo carregou
    Sleep    1s

    # Verifica se o carrinho está vazio no início
    Update Cart Display From Frontend
    Element Should Contain    id:cart-total    R$ 0.00

    # Adiciona o primeiro item
    Click Button    css=[onclick="addToCart('item1')"]
    # Aguarda a atualização do JS
    Sleep    1s
    Update Cart Display From Frontend
    Element Should Contain    id:cart-items    Camisa - R$ 49.90
    Element Should Contain    id:cart-total    R$ 49.90

    # Adiciona o segundo item
    Click Button    css=[onclick="addToCart('item2')"]
    # Aguarda a atualização do JS
    Sleep    1s
    Update Cart Display From Frontend
    Element Should Contain    id:cart-items    Calça Jeans - R$ 99.90
    # FIX: Removido o comentário da string esperada, pois o elemento só contém o valor.
    Element Should Contain    id:cart-total    R$ 149.80

    [Teardown]    Close Browser

Cenário: Limpar Carrinho
    [Tags]    FuncionalidadeCarrinho
    # Adicionar as opções para o Chrome aqui
    Open Browser    ${URL}    ${BROWSER}    options=add_argument("--headless");add_argument("--no-sandbox");add_argument("--disable-dev-shm-usage");add_argument("--disable-gpu")
    Maximize Browser Window
    Wait Until Page Contains Element    css:body
    # Pequena pausa para garantir que tudo carregou
    Sleep    1s

    # Adiciona alguns itens para poder limpar
    Click Button    css=[onclick="addToCart('item1')"]
    # Aguarda a atualização do JS
    Sleep    0.5s
    Click Button    css=[onclick="addToCart('item3')"]
    # Aguarda a atualização do JS
    Sleep    1s
    Update Cart Display From Frontend
    # Verifica que o total não é zero antes de limpar
    Element Should Not Contain    id:cart-total    R$ 0.00

    # Limpa o carrinho
    Click Button    id:clear-cart-button
    # Aguarda a atualização do JS
    Sleep    1s
    Update Cart Display From Frontend
    Element Should Contain    id:cart-items    Carrinho vazio
    Element Should Contain    id:cart-total    R$ 0.00

    [Teardown]    Close Browser

Cenário: Finalizar Compra
    [Tags]    FuncionalidadeCarrinho
    # Adicionar as opções para o Chrome aqui
    Open Browser    ${URL}    ${BROWSER}    options=add_argument("--headless");add_argument("--no-sandbox");add_argument("--disable-dev-shm-usage");add_argument("--disable-gpu")
    Maximize Browser Window
    Wait Until Page Contains Element    css:body
    # Pequena pausa para garantir que tudo carregou
    Sleep    1s

    # Adiciona um item para finalizar a compra
    Click Button    css=[onclick="addToCart('item4')"]
    # Aguarda a atualização do JS
    Sleep    1s
    Update Cart Display From Frontend
    Element Should Contain    id:cart-total    R$ 29.90

    # Finaliza a compra
    Click Button    id:checkout-button
    Wait Until Element Is Visible    id:checkout-popup    timeout=5s
    Element Should Contain    id:checkout-popup    Compra Finalizada!
    Element Should Contain    id:checkout-popup    Seu pedido foi processado com sucesso.

    # Fecha o popup
    Click Button    css:#checkout-popup button
    Wait Until Element Is Not Visible    id:checkout-popup    timeout=5s

    # Verifica se o carrinho foi limpo após finalizar a compra
    Update Cart Display From Frontend
    Element Should Contain    id:cart-items    Carrinho vazio
    Element Should Contain    id:cart-total    R$ 0.00

    [Teardown]    Close Browser

***Keywords***
Update Cart Display From Frontend
    # Este é um workaround para garantir que o DOM seja atualizado
    # O JavaScript no navegador já faz isso, mas o Robot pode precisar de um "empurrão"
    # ou de uma pequena pausa para o JS rodar. O "Sleep" já ajuda.
    # Em aplicações mais complexas, você pode precisar de 'Wait Until Element Is Enabled' ou similar.
    Log    Atualizando a exibição do carrinho...
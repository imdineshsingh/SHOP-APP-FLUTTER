import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_flutter/providers/cart.dart';
import 'package:shop_app_flutter/providers/orders.dart';
import 'package:shop_app_flutter/widgets/cart_item.dart' as ci;

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Cart")),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total",
                      style: TextStyle(fontSize: 20),
                    ),
                    Spacer(),
                    Chip(
                      label: Text(
                        '\$ ${cart.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                            color:
                                Theme.of(context).primaryTextTheme.title.color),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    OrderButton(cart: cart)
                  ],
                )),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) => ci.CartItem(
                id: cart.items.values.toList()[i].id,
                productId: cart.items.keys.toList()[i],
                title: cart.items.values.toList()[i].title,
                quantity: cart.items.values.toList()[i].quantity,
                price: cart.items.values.toList()[i].price,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isLoading ? CircularProgressIndicator() : Text('Order Now'),
      textColor: Theme.of(context).primaryColor,
      onPressed: (widget.cart.totalAmount <= 0 ||  _isLoading) ? null : () async{
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(widget.cart.items.values.toList(), widget.cart.totalAmount);
              setState(() {
                _isLoading=false;
              });
              widget.cart.clearCart();
            },
    );
  }
}

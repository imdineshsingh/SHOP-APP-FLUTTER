import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_flutter/providers/orders.dart' show Orders;
import 'package:shop_app_flutter/widgets/app_drawer.dart';
import 'package:shop_app_flutter/widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isLoading = false;

  Future _ordersFuture;

  Future _obtainOrdersResult() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    /*Future.delayed(Duration.zero).then((_) async{
      setState(() {
        _isLoading=true;
      });
      await Provider.of<Orders>(context).fetchAndSetOrders();
      setState(() {
        _isLoading=false;
      });

    });*/
    //==>  IF WE DON'T WANNA LISTEN I.E. LISTEN= FALSE

    /*_isLoading = true;
    Provider.of<Orders>(context, listen: false).fetchAndSetOrders().then((
        value) =>
    {
      setState(() {
        _isLoading = false;
      })
    });*/

    _ordersFuture = _obtainOrdersResult();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // final ordersData = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
          future: _ordersFuture,
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (dataSnapshot.error != null) {
                //do error handleing
                return Center(
                  child: Text('Án Error Occurred!'),
                );
              } else {
                return Consumer<Orders>(
                    builder: (ctx, orderData, child) => ListView.builder(
                        itemCount: orderData.orders.length,
                        itemBuilder: (ctx, i) =>
                            OrderItem(orderData.orders[i])));
              }
            }
          }),
    );
  }
}

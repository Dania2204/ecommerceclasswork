import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/* -----------------------------
   PRODUCT MODEL
--------------------------------*/
class Product {
  final String name;
  final double price;
  final String imageUrl;

  const Product(this.name, this.price, this.imageUrl);
}

/* -----------------------------
   APP MAIN
--------------------------------*/
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Ecommerce App",
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF7F3FA),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

/* -----------------------------
   GLOBAL CART LIST
--------------------------------*/
List<Product> cart = [];

/* -----------------------------
   HOME PAGE
--------------------------------*/
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final List<Product> products = const [
    Product(
      "Shoes",
      50,
      "https://cdn-icons-png.flaticon.com/512/814/814513.png",
    ),
    Product(
      "T-Shirt",
      20,
      "https://cdn-icons-png.flaticon.com/512/892/892458.png",
    ),
    Product(
      "Hat",
      15,
      "https://cdn-icons-png.flaticon.com/512/616/616408.png",
    ),
    Product(
      "Jacket",
      80,
      "https://cdn-icons-png.flaticon.com/512/892/892460.png",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Arrivals"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartPage()),
              );
            },
          )
        ],
      ),

      /* GRID PRODUCTS */
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: GridView.builder(
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
          ),
          itemBuilder: (context, index) {
            final product = products[index];

            return ProductCard(
              product: product,
              onAdd: () {
                cart.add(product);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("${product.name} added to cart!"),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailsPage(product: product),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

/* -----------------------------
   PRODUCT CARD WIDGET
--------------------------------*/
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAdd;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onAdd,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Expanded(
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image_not_supported, size: 60);
                },
              ),
            ),
            const SizedBox(height: 10),
            Text(
              product.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text("\$${product.price}"),
            const SizedBox(height: 10),

            /* ADD TO CART ICON */
            IconButton(
              icon: const Icon(Icons.add_shopping_cart),
              onPressed: onAdd,
            )
          ],
        ),
      ),
    );
  }
}

/* -----------------------------
   DETAILS PAGE
--------------------------------*/
class DetailsPage extends StatelessWidget {
  final Product product;

  const DetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Product Details")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Image.network(
              product.imageUrl,
              height: 200,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.image_not_supported, size: 100);
              },
            ),
            const SizedBox(height: 20),
            Text(
              product.name,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "\$${product.price}",
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 30),

            ElevatedButton.icon(
              icon: const Icon(Icons.shopping_cart),
              label: const Text("Add to Cart"),
              onPressed: () {
                cart.add(product);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Added to cart!"),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              child: const Text("Go to Cart"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartPage()),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

/* -----------------------------
   CART PAGE
--------------------------------*/
class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => CartPageState();
}

class CartPageState extends State<CartPage> {
  bool paid = false;

  double getTotal() {
    double total = 0;
    for (var item in cart) {
      total += item.price;
    }
    return total;
  }

  void checkout() {
    setState(() {
      paid = true;
      cart.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cart")),
      body: paid
          ? const Center(
              child: Text(
                "Payment Successful ✅",
                style: TextStyle(fontSize: 25),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: cart.isEmpty
                      ? const Center(
                          child: Text(
                            "Cart is empty 🛒",
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      : ListView.builder(
                          itemCount: cart.length,
                          itemBuilder: (context, index) {
                            final product = cart[index];

                            return ListTile(
                              leading: Image.network(
                                product.imageUrl,
                                width: 50,
                                errorBuilder: (c, e, s) {
                                  return const Icon(Icons.image);
                                },
                              ),
                              title: Text(product.name),
                              subtitle: Text("\$${product.price}"),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  setState(() {
                                    cart.removeAt(index);
                                  });
                                },
                              ),
                            );
                          },
                        ),
                ),

                /* TOTAL + CHECKOUT */
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        "Total: \$${getTotal()}",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.payment),
                        label: const Text("Checkout"),
                        onPressed: cart.isEmpty ? null : checkout,
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SmartStock',
      theme: ThemeData(primarySwatch: Colors.green, useMaterial3: true),
      home: const LoginScreen(),
    );
  }
}

// gd
List<Map<String, dynamic>> globalProducts = [
  {
    "name": "Tomato",
    "price": 250,
    "stock": 10,
    "sold": 0,
    "icon": Icons.local_florist,
  },
  {"name": "Carrot", "price": 180, "stock": 5, "sold": 0, "icon": Icons.eco},
  {
    "name": "Milk",
    "price": 320,
    "stock": 3,
    "sold": 0,
    "icon": Icons.local_drink,
  },
  {
    "name": "Biscuits",
    "price": 150,
    "stock": 12,
    "sold": 0,
    "icon": Icons.cookie,
  },
];

double totalWeeklySales = 42500.0;
List<List<Map<String, dynamic>>> orderHistory = [];

// login
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String role = "customer";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 280,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_basket_rounded,
                    size: 80,
                    color: Colors.white,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "SmartStock",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Your Grocery, Simplified",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: role,
                    decoration: const InputDecoration(
                      labelText: "Select Role",
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: "customer",
                        child: Text("Customer"),
                      ),
                      DropdownMenuItem(value: "staff", child: Text("Staff")),
                      DropdownMenuItem(
                        value: "owner",
                        child: Text("Owner/Admin"),
                      ),
                    ],
                    onChanged: (val) => setState(() => role = val!),
                  ),
                  const SizedBox(height: 20),
                  const TextField(
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        if (role == "customer") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CustomerHome(),
                            ),
                          );
                        } else if (role == "staff") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const StaffScreen(),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const OwnerDashboard(),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        "LOGIN",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//customer
class CustomerHome extends StatefulWidget {
  const CustomerHome({super.key});
  @override
  State<CustomerHome> createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {
  static List<Map<String, dynamic>> cartItems = [];
  double? myBudget = 1500.0;

  double get currentTotal =>
      cartItems.fold(0, (sum, item) => sum + (item['price'] as int));

  void _showBudgetDialog() {
    TextEditingController budgetController = TextEditingController(
      text: myBudget != null ? myBudget!.toInt().toString() : "",
    );
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Set Spending Limit"),
        content: TextField(
          controller: budgetController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: "Budget (Rs.)",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => myBudget = null);
              Navigator.pop(context);
            },
            child: const Text(
              "Remove Limit",
              style: TextStyle(color: Colors.red),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (budgetController.text.isNotEmpty) {
                setState(() => myBudget = double.parse(budgetController.text));
                Navigator.pop(context);
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Widget budgetTrackerUI() {
    if (myBudget == null) {
      return InkWell(
        onTap: _showBudgetDialog,
        child: Container(
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.green.shade200),
          ),
          child: const Row(
            children: [
              Icon(Icons.add_chart, color: Colors.green),
              SizedBox(width: 10),
              Text(
                "Tap to set a shopping budget",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }
    double progress = currentTotal / myBudget!;
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Budget Tracker",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.edit, size: 18),
                onPressed: _showBudgetDialog,
              ),
            ],
          ),
          LinearProgressIndicator(
            value: progress > 1 ? 1 : progress,
            color: progress > 0.9 ? Colors.red : Colors.green,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              "Spent: Rs. ${currentTotal.toInt()} / Limit: Rs. ${myBudget!.toInt()}",
            ),
          ),
        ],
      ),
    );
  }

  Widget categoryItem(String name, IconData icon) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.green.shade100,
          child: Icon(icon, color: Colors.green.shade700, size: 30),
        ),
        const SizedBox(height: 8),
        Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget productGridItem(Map<String, dynamic> product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Icon(
                product['icon'],
                size: 50,
                color: Colors.green.shade700,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        product['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text("Rs. ${product['price']}"),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: product['stock'] > 0
                          ? () {
                              if (myBudget != null &&
                                  (currentTotal + product['price'] >
                                      myBudget!)) {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text("Budget Alert!"),
                                    content: Text(
                                      "Adding ${product['name']} exceeds your budget.",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            cartItems.add(product);
                                            product['stock']--;
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Add Anyway"),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                setState(() {
                                  cartItems.add(product);
                                  product['stock']--;
                                });
                              }
                            }
                          : null,
                      child: Text(product['stock'] > 0 ? "Add" : "Out"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: const Text("SmartStock Store"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Badge(
              label: Text("${cartItems.length}"),
              child: const Icon(Icons.shopping_cart),
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CartScreen(cartItems: cartItems),
              ),
            ).then((_) => setState(() {})),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            budgetTrackerUI(),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Search...",
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              "Categories",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                categoryItem("Veg", Icons.eco),
                categoryItem("Fruits", Icons.apple),
                categoryItem("Milk", Icons.local_drink),
                categoryItem("More", Icons.more_horiz),
              ],
            ),
            const SizedBox(height: 25),
            const Text(
              "Products",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.68,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemCount: globalProducts.length,
              itemBuilder: (context, index) =>
                  productGridItem(globalProducts[index]),
            ),
          ],
        ),
      ),
    );
  }
}

//cart
class CartScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  const CartScreen({super.key, required this.cartItems});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    int total = widget.cartItems.fold(
      0,
      (sum, item) => sum + (item['price'] as int),
    );
    return Scaffold(
      appBar: AppBar(title: const Text("Your Cart")),
      body: widget.cartItems.isEmpty
          ? const Center(child: Text("Cart is empty"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.cartItems.length,
                    itemBuilder: (context, i) {
                      final item = widget.cartItems[i];
                      return ListTile(
                        title: Text(item['name']),
                        subtitle: Text("Rs. ${item['price']}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              globalProducts.firstWhere(
                                (p) => p['name'] == item['name'],
                              )['stock']++;
                              widget.cartItems.removeAt(i);
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        "Total: Rs. $total",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              totalWeeklySales += total;
                              // Track 'sold' count for insights
                              for (var item in widget.cartItems) {
                                globalProducts.firstWhere(
                                  (p) => p['name'] == item['name'],
                                )['sold']++;
                              }
                              orderHistory.add(List.from(widget.cartItems));
                              widget.cartItems.clear();
                            });
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Purchase Successful!"),
                              ),
                            );
                          },
                          child: const Text("Checkout"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

//staff
class StaffScreen extends StatefulWidget {
  const StaffScreen({super.key});
  @override
  State<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen> {
  Map<String, dynamic>? selectedProduct;
  int quantity = 1;
  int billTotal = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Staff Inventory"),
        backgroundColor: Colors.orange,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "🚨 Low Stock Alerts",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ...globalProducts
              .where((p) => p['stock'] <= 3)
              .map(
                (p) => Card(
                  color: Colors.red.shade50,
                  child: ListTile(
                    title: Text("${p['name']} is LOW!"),
                    trailing: Text("${p['stock']} left"),
                  ),
                ),
              ),

          const Divider(height: 40),
          const Text(
            "🧾 Billing System",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<Map<String, dynamic>>(
            hint: const Text("Select Product"),
            value: selectedProduct,
            items: globalProducts
                .map((p) => DropdownMenuItem(value: p, child: Text(p['name'])))
                .toList(),
            onChanged: (val) => setState(() => selectedProduct = val),
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
          const SizedBox(height: 10),
          TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Quantity",
              border: OutlineInputBorder(),
            ),
            onChanged: (val) => quantity = int.tryParse(val) ?? 1,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              if (selectedProduct != null &&
                  selectedProduct!['stock'] >= quantity) {
                setState(() {
                  billTotal = selectedProduct!['price'] * quantity;
                  selectedProduct!['stock'] -= quantity;
                  selectedProduct!['sold'] += quantity;
                  totalWeeklySales += billTotal;
                });
              }
            },
            child: const Text("Process Bill"),
          ),
          const SizedBox(height: 10),
          Text(
            "Total: Rs. $billTotal",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),

          const Divider(height: 40),
          const Text(
            "📦 Update Stock",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ...globalProducts.map(
            (p) => ListTile(
              title: Text(p['name']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () => setState(() {
                      if (p['stock'] > 0) p['stock']--;
                    }),
                  ),
                  Text("${p['stock']}"),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => setState(() => p['stock']++),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// owner
class OwnerDashboard extends StatelessWidget {
  const OwnerDashboard({super.key});

  int getLowStockCount() => globalProducts.where((p) => p['stock'] <= 3).length;

  String getMostSoldProduct() {
    var sorted = List.from(globalProducts);
    sorted.sort((a, b) => b['sold'].compareTo(a['sold']));
    return sorted.first['sold'] > 0 ? sorted.first['name'] : "None yet";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Owner Analytics"),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Weekly Revenue",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(25),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.blueGrey, Colors.black87],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text(
                    "TOTAL SALES",
                    style: TextStyle(color: Colors.white70),
                  ),
                  Text(
                    "Rs. ${totalWeeklySales.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
            const Text(
              "📊 Business Insights",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                leading: const Icon(Icons.warning, color: Colors.red),
                title: const Text("Low Stock Items"),
                trailing: Text("${getLowStockCount()}"),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.local_fire_department,
                  color: Colors.orange,
                ),
                title: const Text("Most Sold Product"),
                subtitle: Text(getMostSoldProduct()),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.trending_up, color: Colors.green),
                title: const Text("Prediction"),
                subtitle: const Text("Sales increasing 📈"),
              ),
            ),

            const SizedBox(height: 30),
            const Text(
              "Live Stock Status",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...globalProducts
                .map(
                  (p) => Card(
                    child: ListTile(
                      leading: Icon(p['icon'], color: Colors.green),
                      title: Text(p['name']),
                      trailing: Text(
                        "Qty: ${p['stock']}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: p['stock'] < 3 ? Colors.red : Colors.black,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }
}

// profile
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile Settings")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
            const SizedBox(height: 20),
            const Text(
              "customer A",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text(
              "customerA@gmail.com",
              style: TextStyle(color: Colors.grey),
            ),
            const Divider(height: 40),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text("Order History"),
              subtitle: Text("${orderHistory.length} orders found"),
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout", style: TextStyle(color: Colors.red)),
              onTap: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

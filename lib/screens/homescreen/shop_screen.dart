import 'package:flutter/material.dart';

class ShopScreen extends StatefulWidget {
  final int xpPoints;
  final Function(int) subtractXp;

  const ShopScreen({super.key, required this.xpPoints, required this.subtractXp});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final List<Map<String, dynamic>> _shopItems = [
    {
      'name': 'Shopping Bag', 
      'price': 1000, 
      'icon': Icons.shopping_bag, 
      'color': const Color(0xFFFF6B35),
      'gradient': [const Color(0xFFFF6B35), const Color(0xFFFF8E53)],
    },
    {
      'name': 'Water Bottle', 
      'price': 700, 
      'icon': Icons.local_drink, 
      'color': const Color(0xFF4FC3F7),
      'gradient': [const Color(0xFF4FC3F7), const Color(0xFF29B6F6)],
    },
    {
      'name': 'Wall Clock', 
      'price': 600, 
      'icon': Icons.access_time, 
      'color': const Color(0xFFBA68C8),
      'gradient': [const Color(0xFFBA68C8), const Color(0xFFAB47BC)],
    },
    {
      'name': 'T-Shirt', 
      'price': 900, 
      'icon': Icons.checkroom, 
      'color': const Color(0xFF66BB6A),
      'gradient': [const Color(0xFF66BB6A), const Color(0xFF4CAF50)],
    },
    {
      'name': 'Headphones', 
      'price': 1200, 
      'icon': Icons.headset, 
      'color': const Color(0xFFFFA726),
      'gradient': [const Color(0xFFFFA726), const Color(0xFFFF9800)],
    },
    {
      'name': 'Notebook', 
      'price': 500, 
      'icon': Icons.book, 
      'color': const Color(0xFF26C6DA),
      'gradient': [const Color(0xFF26C6DA), const Color(0xFF00ACC1)],
    },
  ];

  void _purchaseItem(int index) {
    final item = _shopItems[index];
    final price = item['price'];
    if (widget.xpPoints >= price) {
      _showOrderForm(index);
    } else {
      _showInsufficientXpDialog(item['name'], price);
    }
  }

  void _showInsufficientXpDialog(String itemName, int price) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Insufficient XP", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
        content: Text("You need $price XP to purchase the $itemName. You currently have ${widget.xpPoints} XP.",
            style: const TextStyle(color: Colors.grey)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), 
            child: const Text("OK", style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  void _showOrderForm(int index) {
    final item = _shopItems[index];
    final price = item['price'];
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();
    final addressController = TextEditingController();
    final pincodeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: item['gradient'],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(item['icon'], size: 30, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['name'], 
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                          Text("$price XP", 
                              style: const TextStyle(fontSize: 16, color: Colors.white70)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildTextField(nameController, "Full Name", Icons.person),
                      const SizedBox(height: 12),
                      _buildTextField(phoneController, "Phone Number", Icons.phone, TextInputType.phone),
                      const SizedBox(height: 12),
                      _buildTextField(emailController, "Email Address", Icons.email, TextInputType.emailAddress),
                      const SizedBox(height: 12),
                      _buildTextField(addressController, "Delivery Address", Icons.home, TextInputType.multiline, 2),
                      const SizedBox(height: 12),
                      _buildTextField(pincodeController, "Pincode (6 digits)", Icons.location_on, TextInputType.number, 1, 6),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (nameController.text.isNotEmpty &&
                            phoneController.text.isNotEmpty &&
                            emailController.text.isNotEmpty &&
                            addressController.text.isNotEmpty &&
                            pincodeController.text.length == 6) {
                          widget.subtractXp(price);
                          Navigator.of(context).pop();
                          _showOrderConfirmation(item['name'], price);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text("Please fill all fields correctly"),
                              backgroundColor: Colors.red[400],
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: item['color'],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 2,
                      ),
                      child: const Text("Place Order", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, 
                        [TextInputType? keyboardType, int maxLines = 1, int? maxLength]) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      maxLength: maxLength,
    );
  }

  void _showOrderConfirmation(String itemName, int price) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle, size: 60, color: Colors.green),
              ),
              const SizedBox(height: 20),
              const Text("Order Placed Successfully!", 
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
              const SizedBox(height: 15),
              Text("Your $itemName has been ordered successfully.", 
                  style: const TextStyle(color: Colors.grey), textAlign: TextAlign.center),
              const SizedBox(height: 10),
              Text("$price XP has been deducted from your account.", 
                  style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.blue)),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text("Great!", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rewards Shop", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // XP Balance Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text("Your XP Balance", 
                    style: TextStyle(fontSize: 16, color: Colors.white70, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Text("${widget.xpPoints} XP", 
                    style: const TextStyle(fontSize: 36, color: Colors.white, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text("Earn more XP by completing videos and quizzes", 
                      style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.9)), 
                      textAlign: TextAlign.center),
                ),
              ],
            ),
          ),
          
          // Shop Items Grid
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFF5F7FA), Color(0xFFE4E7EC)],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, 
                    crossAxisSpacing: 16, 
                    mainAxisSpacing: 16, 
                    childAspectRatio: 0.75,
                  ),
                  itemCount: _shopItems.length,
                  itemBuilder: (context, index) {
                    final item = _shopItems[index];
                    final canAfford = widget.xpPoints >= item['price'];
                    
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              colors: [Colors.white, Colors.grey[50]!],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Item Icon with Gradient Background
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: item['gradient'],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: item['color'].withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Icon(item['icon'], size: 32, color: Colors.white),
                                ),
                                
                                // Item Details
                                Column(
                                  children: [
                                    Text(item['name'], 
                                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                                        textAlign: TextAlign.center),
                                    const SizedBox(height: 6),
                                    Text("${item['price']} XP", 
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: item['color'])),
                                  ],
                                ),
                                
                                // Purchase Button
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () => _purchaseItem(index),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: canAfford ? item['color'] : Colors.grey[400],
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      elevation: 2,
                                    ),
                                    child: Text(
                                      canAfford ? "Purchase" : "Need More XP", 
                                      style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
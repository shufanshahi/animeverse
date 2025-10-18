import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseTestScreen extends StatefulWidget {
  const SupabaseTestScreen({super.key});

  @override
  State<SupabaseTestScreen> createState() => _SupabaseTestScreenState();
}

class _SupabaseTestScreenState extends State<SupabaseTestScreen> {
  String _result = 'Ready to test...';
  bool _isLoading = false;

  Future<void> _testSupabase() async {
    setState(() {
      _isLoading = true;
      _result = 'Testing Supabase connection...';
    });

    try {
      final supabase = Supabase.instance.client;
      
      // Test 1: Basic connection
      _updateResult('✅ Supabase client initialized');
      
      // Test 2: Check if profiles table exists
      _updateResult('🔍 Testing profiles table...');
      
      try {
        final response = await supabase
            .from('profiles')
            .select('email')
            .limit(1);
        
        _updateResult('✅ Profiles table exists! Found ${response.length} records');
        
        // Test 3: Try to find specific email
        _updateResult('🔍 Testing email query...');
        final emailTest = await supabase
            .from('profiles')
            .select()
            .eq('email', 'sunwookoong@gmail.com')
            .maybeSingle();
        
        if (emailTest != null) {
          _updateResult('✅ Found profile: ${emailTest['email']}');
        } else {
          _updateResult('🚫 No profile found for sunwookoong@gmail.com');
        }
        
      } catch (tableError) {
        _updateResult('❌ Table error: $tableError');
      }
      
    } catch (e) {
      _updateResult('❌ Connection error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _updateResult(String message) {
    setState(() {
      _result += '\n$message';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supabase Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _isLoading ? null : _testSupabase,
              child: _isLoading 
                  ? const CircularProgressIndicator()
                  : const Text('Test Supabase Connection'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _result,
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
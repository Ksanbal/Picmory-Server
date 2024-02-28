import 'package:flutter/material.dart';
import 'package:picmory/main.dart';
import 'package:picmory/models/memory/memory_model.dart';
import 'package:picmory/repositories/meory_repository.dart';

class MemoryRetrieveViewmodel extends ChangeNotifier {
  final MemoryRepository _memoryRepository = MemoryRepository();

  MemoryModel? _memory;
  MemoryModel? get memory => _memory;
  getMemory(int memoryId) async {
    final data = await _memoryRepository.retrieve(
      userId: supabase.auth.currentUser!.id,
      memoryId: memoryId,
    );

    if (data != null) {
      _memory = data;
      notifyListeners();
    }
  }

  // TextEditingController _
}

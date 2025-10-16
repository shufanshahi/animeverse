class LMStudioRequestModel {
  final String model;
  final List<LMStudioMessage> messages;
  final double temperature;
  final int maxTokens;
  final bool stream;

  LMStudioRequestModel({
    this.model = 'local-model',
    required this.messages,
    this.temperature = 0.7,
    this.maxTokens = 1000,
    this.stream = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'model': model,
      'messages': messages.map((message) => message.toJson()).toList(),
      'temperature': temperature,
      'max_tokens': maxTokens,
      'stream': stream,
    };
  }
}

class LMStudioMessage {
  final String role;
  final String content;

  LMStudioMessage({
    required this.role,
    required this.content,
  });

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'content': content,
    };
  }
}

class LMStudioResponseModel {
  final String id;
  final String object;
  final int created;
  final String model;
  final List<LMStudioChoice> choices;
  final LMStudioUsage usage;

  LMStudioResponseModel({
    required this.id,
    required this.object,
    required this.created,
    required this.model,
    required this.choices,
    required this.usage,
  });

  factory LMStudioResponseModel.fromJson(Map<String, dynamic> json) {
    return LMStudioResponseModel(
      id: json['id'] as String,
      object: json['object'] as String,
      created: json['created'] as int,
      model: json['model'] as String,
      choices: (json['choices'] as List)
          .map((choice) => LMStudioChoice.fromJson(choice))
          .toList(),
      usage: LMStudioUsage.fromJson(json['usage']),
    );
  }
}

class LMStudioChoice {
  final int index;
  final LMStudioMessage message;
  final String finishReason;

  LMStudioChoice({
    required this.index,
    required this.message,
    required this.finishReason,
  });

  factory LMStudioChoice.fromJson(Map<String, dynamic> json) {
    return LMStudioChoice(
      index: json['index'] as int,
      message: LMStudioMessage(
        role: json['message']['role'] as String,
        content: json['message']['content'] as String,
      ),
      finishReason: json['finish_reason'] as String,
    );
  }
}

class LMStudioUsage {
  final int promptTokens;
  final int completionTokens;
  final int totalTokens;

  LMStudioUsage({
    required this.promptTokens,
    required this.completionTokens,
    required this.totalTokens,
  });

  factory LMStudioUsage.fromJson(Map<String, dynamic> json) {
    return LMStudioUsage(
      promptTokens: json['prompt_tokens'] as int,
      completionTokens: json['completion_tokens'] as int,
      totalTokens: json['total_tokens'] as int,
    );
  }
}
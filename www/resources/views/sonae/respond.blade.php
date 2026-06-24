<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>SONAE 安否回答</title>
    <style>
        body { font-family: system-ui, sans-serif; margin: 1rem; line-height: 1.5; }
        label { display: block; margin-top: 1rem; font-weight: 600; }
        select, textarea { width: 100%; max-width: 24rem; padding: 0.5rem; margin-top: 0.25rem; }
        button { margin-top: 1.5rem; padding: 0.75rem 1.5rem; font-size: 1rem; }
        .meta { color: #555; margin-bottom: 1rem; }
        .status { background: #e8f5e9; padding: 0.75rem; border-radius: 4px; margin-bottom: 1rem; }
        .error { color: #b00020; }
    </style>
</head>
<body>
    <h1>SONAE 安否回答</h1>
    @if ($chapterName)
        <p class="meta">{{ $chapterName }} / {{ $memberName }} さん</p>
    @endif

    @if (session('status'))
        <p class="status">{{ session('status') }}</p>
    @endif

    @if ($errors->any())
        <p class="error">{{ $errors->first() }}</p>
    @endif

    <form method="post" action="{{ route('sonae.respond.store', ['token' => $token]) }}">
        @csrf

        <label for="safety_status">安否</label>
        <select name="safety_status" id="safety_status" required>
            @foreach (['safe' => '無事', 'minor_injury' => '軽傷', 'serious_injury' => '重傷', 'evacuating' => '避難中', 'hard_to_answer' => '回答不可に近い状況'] as $value => $label)
                <option value="{{ $value }}" @selected(old('safety_status', $existing?->safety_status) === $value)>{{ $label }}</option>
            @endforeach
        </select>

        <label for="activity_status">活動状況</label>
        <select name="activity_status" id="activity_status" required>
            @foreach (['normal' => '通常活動可能', 'partially_affected' => '一部影響あり', 'difficult' => '活動困難'] as $value => $label)
                <option value="{{ $value }}" @selected(old('activity_status', $existing?->activity_status) === $value)>{{ $label }}</option>
            @endforeach
        </select>

        <label for="meeting_attendance_status">定例会参加可否</label>
        <select name="meeting_attendance_status" id="meeting_attendance_status" required>
            @foreach (['can_attend' => '参加可能', 'cannot_attend' => '参加困難', 'undecided' => '未定'] as $value => $label)
                <option value="{{ $value }}" @selected(old('meeting_attendance_status', $existing?->meeting_attendance_status) === $value)>{{ $label }}</option>
            @endforeach
        </select>

        <label for="comment">コメント（任意）</label>
        <textarea name="comment" id="comment" rows="4" maxlength="1000">{{ old('comment', $existing?->comment) }}</textarea>

        <button type="submit">回答を送信</button>
    </form>
</body>
</html>

// ─── Access Code Generation ──────────────────────────────────────

function generateCodeString() {
  const letters = [0,1,2].map(() => randomChar(CODE_LETTERS)).join('');
  const digits  = [0,1,2].map(() => randomChar(CODE_DIGITS)).join('');
  return letters + '-' + digits;
}

async function generateAccessCode(format, customCode) {
  if (format === 'custom') {
    const code = (customCode || '').toUpperCase().trim();
    if (!/^[A-Z0-9]{3,20}$/.test(code)) {
      throw new Error(t('dashboard.customCodeError'));
    }
    if (await checkCodeExists(code)) {
      throw new Error(t('dashboard.customCodeExists', { code }));
    }
    return code;
  }

  let code;
  let attempts = 0;
  do {
    code = generateCodeString();
    attempts++;
    if (attempts > 20) throw new Error(t('dashboard.codeGenerationFailed'));
  } while (await checkCodeExists(code));
  return code;
}

async function checkCodeExists(code) {
  const { data } = await supabaseClient
    .from('uploads')
    .select('id')
    .eq('access_code', code)
    .maybeSingle();
  return data !== null;
}

// ─── Exit Word ───────────────────────────────────────────────────

function pickExitWord() {
  return EXIT_WORDS[Math.floor(Math.random() * EXIT_WORDS.length)];
}

function pickExitWordByComplexity(complexity) {
  switch (complexity) {
    case 'long':   return LONG_EXIT_WORDS[Math.floor(Math.random() * LONG_EXIT_WORDS.length)];
    case 'phrase': return pickTwoWordPhrase();
    case 'pin':    return pickNumericPin();
    default:       return pickExitWord();
  }
}

function pickTwoWordPhrase() {
  const a = pickExitWord();
  let b;
  do { b = pickExitWord(); } while (b === a);
  return a + ' ' + b;
}

function pickNumericPin() {
  return [0,1,2,3].map(() => randomChar('0123456789')).join('');
}

async function hashWord(word) {
  const data = new TextEncoder().encode(word.toLowerCase().trim());
  const buf  = await crypto.subtle.digest('SHA-256', data);
  return Array.from(new Uint8Array(buf))
    .map(b => b.toString(16).padStart(2, '0'))
    .join('');
}

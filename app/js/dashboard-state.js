// ─── Exit Word Lists ─────────────────────────────────────────────
const EXIT_WORDS = [
  'maple', 'river', 'cloud', 'stone', 'bread', 'storm', 'flame',
  'lunar', 'amber', 'cedar', 'crane', 'ember', 'frost', 'grove',
  'haven', 'heron', 'lemon', 'lilac', 'marsh', 'north', 'ocean',
  'olive', 'outer', 'pearl', 'pilot', 'pine',  'plumb', 'polar',
  'prism', 'quill', 'radar', 'rally', 'rapid', 'raven', 'ridge',
  'robin', 'rocky', 'rover', 'sabre', 'scout', 'shade', 'shelf',
  'shore', 'sigma', 'silk',  'slate', 'solar', 'sonic', 'spark',
  'spire', 'spoke', 'spore', 'squid', 'staff', 'stalk', 'stark',
  'stern', 'stoic', 'stork', 'sugar', 'swift', 'sword', 'thorn',
  'tiger', 'titan', 'torch', 'tower', 'trace', 'track', 'trail',
  'train', 'trawl', 'trend', 'trout', 'trunk', 'trust', 'tulip',
  'tundra','ultra', 'union', 'urban', 'valor', 'vapor', 'vault',
  'venus', 'viper', 'vista', 'vitae', 'vivid', 'vocal', 'wagon',
  'waltz', 'watch', 'water', 'wheat', 'wheel', 'winch', 'winds',
  'witch', 'wolfe', 'woods', 'world', 'wrath', 'xenon', 'yarns',
];

const LONG_EXIT_WORDS = [
  'anchor', 'basket', 'beacon', 'blanket', 'cabinet', 'captain',
  'careful', 'central', 'chapter', 'charter', 'cluster', 'coastal',
  'comfort', 'council', 'counter', 'current', 'curtain', 'decimal',
  'distant', 'eastern', 'evening', 'express', 'falling', 'feature',
  'federal', 'finding', 'flowing', 'forward', 'freedom', 'general',
  'granite', 'harbour', 'harvest', 'heading', 'highway', 'history',
  'horizon', 'justice', 'kitchen', 'landing', 'lantern', 'lasting',
  'morning', 'network', 'outdoor', 'passage', 'quarter', 'railway',
  'section', 'shelter', 'thunder', 'venture', 'western', 'younger',
];

const CODE_LETTERS = 'ABCDEFGHJKMNPQRSTUVWXYZ';
const CODE_DIGITS  = '23456789';

// ─── Module state ────────────────────────────────────────────────
let currentTier   = 'free';
let currentRole   = 'teacher';
let editTargetId  = null;
let allUploads    = [];
let allSummaries  = {};

const MAX_UPLOAD_BYTES = 50 * 1024 * 1024;
let pendingImages = [];  // { blob, url, name } — queued for upload on submit

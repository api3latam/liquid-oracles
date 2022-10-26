import { randomBytes } from 'crypto';

export function generateKey(size: number = 32) {
  const buffer = randomBytes(size);
  const key = buffer.toString('base64');
  console.log(key);
};

generateKey()

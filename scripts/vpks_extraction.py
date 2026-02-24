import vpk
import os
import shutil

vpks_dir = './vpks'
output_dir = '.'

for filename in os.listdir(vpks_dir):
    if filename.endswith('_dir.vpk'):
        print(f"Extracting {filename}...")
        try:
            pak = vpk.open(os.path.join(vpks_dir, filename))
            for path in pak:
                out_path = os.path.join(output_dir, path.replace('\\', '/'))
                os.makedirs(os.path.dirname(out_path), exist_ok=True)
                try:
                    pak[path].save(out_path)
                except Exception as e:
                    print(f"Error in {path}: {e}")
        except Exception as e:
            print(f"Error in {filename}: {e}")
print("Done!")
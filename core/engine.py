import subprocess
import logging
import os
import json
from typing import List, Dict, Any, Optional

class Engine:
    def __init__(self, config_path: str = "config/config.json"):
        self.config = self._load_json(config_path)
        self._setup_logging()

    def _load_json(self, path: str) -> Dict:
        with open(path, 'r') as f:
            return json.load(f)

    def _setup_logging(self):
        logging.basicConfig(
            level=getattr(logging, self.config['settings']['log_level']),
            format='%(asctime)s - %(levelname)s - %(message)s'
        )

    def execute(self, cmd: str, shell: bool = True) -> subprocess.CompletedProcess:
        """
        The primary execution engine. Handles command routing
        and process management.
        """
        logging.info(f"Executing: {cmd}")
        try:
            # Using subprocess.run for synchronous execution of tools
            result = subprocess.run(
                cmd,
                shell=shell,
                text=True,
                capture_output=False # We want the tool output to go straight to the TUI
            )
            return result
        except Exception as e:
            logging.error(f"Execution error: {e}")
            raise e

    def run_bash_module(self, module_path: str, args: List[str] = []):
        """
        Runs a bash script from the modules directory.
        """
        full_cmd = f"bash {module_path} {' '.join(args)}"
        return self.execute(full_cmd)

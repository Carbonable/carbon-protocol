# scripts/deploy.py
import os
from nile.nre import NileRuntimeEnvironment
from nile.core.call_or_invoke import call_or_invoke


def run(nre: NileRuntimeEnvironment):
    print("Compiling contracts…")

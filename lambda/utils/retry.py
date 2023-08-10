import random, time
from typing import TypeVar, Callable
T = TypeVar('T')


def retry(fn: Callable[[], T], retries: int, backoff_in_seconds: int = 0) -> T:
    x = 0
    while True:
        try:
            return fn()
        except:
            if x == retries:
                raise
            else:
                wait = backoff_in_seconds
                if backoff_in_seconds > 0:
                    wait = (backoff_in_seconds * 2 ** x + random.uniform(0, 1))
                print(f"attempt #{x+1} fail, next try in {wait} seconds")
                time.sleep(wait)
                x += 1


def with_backoff(fn: Callable[[], T], retries: int = 5, backoff_in_seconds: int = 1) -> T:
    return retry(fn, retries, backoff_in_seconds)


def with_backoff_decorator(ExceptionToCheck, default=None, tries: int =4, delay: int =3, backoff: int =2, logger=None):
    """Retry calling the decorated function using an exponential backoff.
    """
    def deco_retry(f):
        def f_retry(*args, **kwargs):
            mtries, mdelay = tries, delay
            try_one_last_time = True
            while mtries > 1:
                try:
                    try_one_last_time = False
                    return f(*args, **kwargs)
                except ExceptionToCheck as e:
                    msg = f"{str(e)}, Retrying in {mdelay} seconds..."
                    if logger:
                        logger.warning(msg)
                    else:
                        print(msg)
                    time.sleep(mdelay)
                    mtries -= 1
                    mdelay *= backoff
            if try_one_last_time:
                try:
                    return f(*args, **kwargs)
                except ExceptionToCheck as e:
                    return default
            return
        return f_retry
    return deco_retry
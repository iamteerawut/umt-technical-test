import  random

def get_pickup_and_dropoff(hop_list, is_disable=False):
    pickup = random.choice(hop_list)
    dropoff = random.choice(hop_list)
    while True:
        if pickup['isDisabled'] == True:
            pickup = random.choice(hop_list)
        if dropoff['isDisabled'] == True or pickup['id'] == dropoff['id']:
            dropoff = random.choice(hop_list)
        if is_disable == False:
            if pickup['isDisabled'] == is_disable and dropoff['isDisabled'] == is_disable and pickup['id'] != dropoff['id']:
                break
        if is_disable == True:
            if pickup['isDisabled'] == is_disable or dropoff['isDisabled'] == is_disable and pickup['id'] != dropoff['id']:
                break
            if pickup['id'] == dropoff['id']:
                break
    return pickup, dropoff
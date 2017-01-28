<?php
/**
 * Definicja interfejsu mechanizmu odsetkowego
 */

namespace LukaszJakubek\SPIO\Bank\Odsetki;

use LukaszJakubek\SPIO\Bank\Rachunek\RachunekInterface;

/**
 * Mechanizm obliczania odsetek
 *
 * @author Łukasz Jakubek <lukasz.jakubek@aplisys.pl>
 */
interface OdsetkiInterface
{
    /**
     * Oblicza wartośc odsetek
     *
     * @param RachunekInterface $rachunek
     * @return int
     */
    public function oblicz(RachunekInterface $rachunek);
}

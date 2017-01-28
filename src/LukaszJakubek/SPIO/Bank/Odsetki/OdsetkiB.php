<?php
/**
 * Definicja mechanizmu odsetkowego typu B
 */

namespace LukaszJakubek\SPIO\Bank\Odsetki;

use LukaszJakubek\SPIO\Bank\Rachunek\RachunekInterface;

/**
 * Mechanizm obliczania odsetek typu B
 *
 * Wartość oprocentowania inna w każdym z 3 przedziałów wartości salda.
 *
 * @author Łukasz Jakubek <lukasz.jakubek@aplisys.pl>
 */
class OdsetkiB implements OdsetkiInterface
{
    /**
     * stała określająca 1. granicę przedziałów
     */
    const LIMIT_0 = 10000;

    /**
     * Stała określająca 2. granicę przedziałów
     */
    const LIMIT_1 = 50000;

    /**
     * Wartość oprocentowania w 1. przedziale w postaci dziesiętnej
     *
     * @var float
     */
    private $oproc0;

    /**
     * Wartość oprocentowania w 2. przedziale w postaci dziesiętnej
     *
     * @var float
     */
    private $oproc1;

    /**
     * Wartość oprocentowania w 3. przedziale w postaci dziesiętnej
     *
     * @var float
     */
    private $oproc2;

    /**
     * Tworzy mechanizm odsetkowy
     *
     * @param float $oprocentowanie0
     * @param float $oprocentowanie1
     * @param float $oprocentowanie2
     */
    public function __construct($oprocentowanie0, $oprocentowanie1, $oprocentowanie2)
    {
        $this->oproc0 = $oprocentowanie0;
        $this->oproc1 = $oprocentowanie1;
        $this->oproc2 = $oprocentowanie2;
    }

    /**
     * Oblicza wartośc odsetek
     *
     * @param RachunekInterface $rachunek
     * @return int
     */
    public function oblicz(RachunekInterface $rachunek)
    {
        if ($rachunek->getSaldo() <= 0) {
            return 0;
        }

        if ($rachunek->getSaldo() < self::LIMIT_0) {
            return (int) ($this->oproc0 * $rachunek->getSaldo());
        } elseif ($rachunek->getSaldo() < self::LIMIT_1) {
            return (int) ($this->oproc0 * self::LIMIT_0)
                + (int) ($this->oproc1 * ($rachunek->getSaldo() - self::LIMIT_0));
        }

        return (int) ($this->oproc0 * self::LIMIT_0)
            + (int) ($this->oproc1 * (self::LIMIT_1 - self::LIMIT_0))
            + (int) ($this->oproc2 * ($rachunek->getSaldo() - self::LIMIT_1));
    }
}
